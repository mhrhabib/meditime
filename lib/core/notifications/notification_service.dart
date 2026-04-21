import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import '../alarm/medicine_alarm_service.dart';
import '../storage/app_database.dart';
import '../storage/data_mappers.dart';
import '../../features/history/domain/entities/dose_log.dart';
import '../../features/medicines/domain/refill_predictor.dart';
import 'notification_channels.dart';

/// Callback for handling notification taps — must be top-level.
@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(NotificationResponse response) {
  _handleNotificationAction(response.actionId, response.payload);
}

/// Callback for background notification actions (Take / Snooze / Skip).
@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse response) {
  _handleNotificationAction(response.actionId, response.payload);
}

/// Process identifying which medicine and what action to take.
void _handleNotificationAction(String? actionId, String? payload) async {
  if (payload == null) return;

  final db = AppDatabase.instance;

  // Payload format: "medicineId|doseIdx|scheduledTimeIso"
  final parts = payload.split('|');
  final medId = parts[0];
  final doseIdx = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
  final scheduledStr =
      parts.length > 2 ? parts[2] : (parts.length > 1 ? parts[1] : null);

  debugPrint('[NotificationService] Action: $actionId for Medicine: $medId');

  // Silence the ringing alarm the moment the user responds — works for
  // Take and Skip alike. Snooze is handled in the cubit which schedules
  // a new reminder. If the payload carries a valid scheduledTime, also
  // cancel the paired alarm entry (matches the scheduler's ID scheme).
  if (actionId == 'take' || actionId == 'skip' || actionId == 'snooze') {
    await MedicineAlarmService.instance.initialize();
    final scheduled =
        scheduledStr != null ? DateTime.tryParse(scheduledStr) : null;
    if (scheduled != null) {
      final today = DateTime.now();
      final todayMid = DateTime(today.year, today.month, today.day);
      final schedDay =
          DateTime(scheduled.year, scheduled.month, scheduled.day);
      final dayOffset = schedDay.difference(todayMid).inDays;
      final notifId = medId.hashCode ^ (dayOffset * 100 + doseIdx);
      await MedicineAlarmService.instance.cancel(notifId);
    }
  }

  if (actionId == 'take') {
    final allMeds = await db.getAllMedicines();
    final medData = allMeds.firstWhere((m) => m.id == medId,
        orElse: () => throw Exception('Medicine not found'));
    final med = DataMappers.medicineFromTable(medData);

    // 1. Decrement stock
    final newStock = (med.stockRemaining - 1).clamp(0, med.stockTotal);

    // 2. Predict refill
    final dosesPerDay = RefillPredictor.parseDosesPerDay(med.schedule);
    final prediction = RefillPredictor.predict(
        currentStock: newStock, dosesPerDay: dosesPerDay);

    final updatedMed = med.copyWith(
      stockRemaining: newStock,
      daysLeft: prediction.daysRemaining,
      isLowStock: prediction.isWarning,
    );
    await db.insertMedicine(DataMappers.medicineToTable(updatedMed));

    // 3. Log event
    final log = DoseLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      medicineId: medId,
      medicineName: med.name,
      dateTime: DateTime.now(),
      status: DoseStatus.taken,
      scheduledDateTime:
          scheduledStr != null ? DateTime.tryParse(scheduledStr) : null,
    );
    await db.insertDoseLog(DataMappers.doseLogToTable(log));
    debugPrint('[NotificationService] Recorded dose for $medId');

    // 4. Fire Refill Alert if hit threshold
    if (prediction.daysRemaining == 3 ||
        prediction.daysRemaining == 1 ||
        newStock == 0) {
      await NotificationService.instance.showNow(
        id: medId.hashCode + 999,
        title: '⚠️ Refill Reminder: ${med.name}',
        body: prediction.message,
        channelId: NotificationChannels.refillAlerts,
      );
    }
  } else if (actionId == 'skip') {
    final log = DoseLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      medicineId: medId,
      medicineName:
          'Unknown', // Ideally we'd fetch it, but skipping is often quick
      dateTime: DateTime.now(),
      status: DoseStatus.skipped,
    );
    await db.insertDoseLog(DataMappers.doseLogToTable(log));
  }
}

/// Singleton wrapper around flutter_local_notifications.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  FlutterLocalNotificationsPlugin get plugin => _plugin;

  /// Call once before runApp.
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone database and set device-local zone so that
    // zonedSchedule fires at the correct wall-clock time.
    tz_data.initializeTimeZones();
    try {
      final tzName = await FlutterTimezone.getLocalTimezone();
      // flutter_timezone 3.x returns a string identifier directly.
      tz.setLocalLocation(tz.getLocation(tzName));
      debugPrint('[NotificationService] timezone set to $tzName');
    } catch (e) {
      debugPrint('[NotificationService] failed to set local timezone: $e');
    }

    // Android init
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS / macOS init
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    // Create Android notification channels
    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        for (final channel in NotificationChannels.all) {
          await androidPlugin.createNotificationChannel(channel);
        }
      }
    }

    _initialized = true;
    debugPrint('[NotificationService] initialized');
  }

  /// Request notification permission (call from UI context).
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await androidPlugin?.requestNotificationsPermission();
      return granted ?? false;
    } else if (Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final granted = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
        critical: true,
      );
      return granted ?? false;
    }
    return false;
  }

  /// Request exact-alarm permission (required on Android 12+ for reliable
  /// scheduled reminders). No-op on iOS. On Android 12+ this opens the
  /// system "Alarms & reminders" settings page — there is no in-app dialog
  /// for this permission.
  Future<bool> requestExactAlarmsPermission() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.scheduleExactAlarm.request();
    return status.isGranted;
  }

  /// Ask the user to whitelist the app from Doze / battery optimization.
  /// Without this, OEM skins (Xiaomi, Samsung, Oppo, etc.) can delay or
  /// drop scheduled notifications and alarms. No-op on iOS.
  Future<bool> requestIgnoreBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.ignoreBatteryOptimizations.request();
    return status.isGranted;
  }

  /// Ask the user to allow full-screen intent — controls whether the alarm
  /// pops over the lockscreen. Auto-granted on Android < 14; opens the
  /// special-access settings page on Android 14+.
  Future<bool> requestFullScreenIntentPermission() async {
    if (!Platform.isAndroid) return true;
    // permission_handler exposes this as systemAlertWindow for now; on
    // Android 14+ devices this routes to the full-screen intent settings
    // page, and on older devices it returns granted immediately.
    final status = await Permission.systemAlertWindow.request();
    return status.isGranted;
  }

  /// True when the OS permits exact alarms (Android 12+). Controls whether
  /// we schedule with [AndroidScheduleMode.exactAllowWhileIdle] or fall back
  /// to the inexact variant — scheduling exact without permission throws.
  Future<bool> _canUseExactAlarms() async {
    if (!Platform.isAndroid) return true;
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await androidPlugin?.canScheduleExactNotifications() ?? false;
  }

  /// Schedule a notification at an exact time (uses zonedSchedule).
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    String channelId = NotificationChannels.medsDefault,
    bool critical = false,
    List<AndroidNotificationAction>? actions,
  }) async {
    final effectiveChannel =
        critical ? NotificationChannels.medsCritical : channelId;

    final androidDetails = AndroidNotificationDetails(
      effectiveChannel,
      effectiveChannel == NotificationChannels.medsCritical
          ? 'Critical Medication Alerts'
          : 'Medication Reminders',
      importance: critical ? Importance.max : Importance.high,
      priority: critical ? Priority.max : Priority.high,
      category: AndroidNotificationCategory.reminder,
      actions: actions ??
          const [
            AndroidNotificationAction('take', '✅ Take',
                showsUserInterface: true),
            AndroidNotificationAction('snooze', '⏰ Snooze',
                showsUserInterface: false),
            AndroidNotificationAction('skip', '❌ Skip',
                showsUserInterface: false),
          ],
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    final scheduleMode = await _canUseExactAlarms()
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      payload: payload,
      androidScheduleMode: scheduleMode,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Dump pending notifications — useful when debugging "no reminders fired".
  Future<int> debugLogPending() async {
    final pending = await _plugin.pendingNotificationRequests();
    debugPrint('[NotificationService] pending: ${pending.length}');
    for (final p in pending) {
      debugPrint('  id=${p.id} title=${p.title} payload=${p.payload}');
    }
    return pending.length;
  }

  /// Show an immediate notification (for testing / demo).
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = NotificationChannels.medsDefault,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      'Medication Reminders',
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      actions: const [
        AndroidNotificationAction('take', '✅ Take', showsUserInterface: true),
        AndroidNotificationAction('snooze', '⏰ Snooze',
            showsUserInterface: false),
        AndroidNotificationAction('skip', '❌ Skip', showsUserInterface: false),
      ],
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _plugin.show(id, title, body, details, payload: payload);
  }

  /// Cancel a single notification by ID.
  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  /// Show a persistent notification for the Emergency Card.
  Future<void> showEmergencyCard({
    required String name,
    required String bloodType,
    required String emergencyContact,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      NotificationChannels.emergencyCard,
      'Emergency Card (Persistent)',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true, // Persistent
      autoCancel: false,
      showWhen: false,
      category: AndroidNotificationCategory.status,
      styleInformation: BigTextStyleInformation(
        'Blood Type: $bloodType\nEmergency Contact: $emergencyContact',
        contentTitle: '🚑 Emergency Medical Card: $name',
        summaryText: 'Swipe down for full details',
      ),
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: false,
      presentSound: false,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _plugin.show(
      888, // Constant ID for emergency card
      '🚑 Emergency Medical Card: $name',
      'Blood Type: $bloodType · Contact: $emergencyContact',
      details,
      payload: 'emergency_card',
    );
  }

  /// Cancel all notifications.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
