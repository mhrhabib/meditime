import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import '../storage/app_database.dart';
import '../storage/data_mappers.dart';
import '../../features/medicines/domain/entities/medicine.dart';
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
  final scheduledStr = parts.length > 2 ? parts[2] : (parts.length > 1 ? parts[1] : null);

  debugPrint('[NotificationService] Action: $actionId for Medicine: $medId');

  if (actionId == 'take') {
    final allMeds = await db.getAllMedicines();
    final medData = allMeds.firstWhere((m) => m.id == medId, orElse: () => throw Exception('Medicine not found'));
    final med = DataMappers.medicineFromTable(medData);

    if (med != null) {
      // 1. Decrement stock
      final newStock = (med.stockRemaining - 1).clamp(0, med.stockTotal);

      // 2. Predict refill
      final dosesPerDay = RefillPredictor.parseDosesPerDay(med.schedule);
      final prediction = RefillPredictor.predict(currentStock: newStock, dosesPerDay: dosesPerDay);

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
      );
      await db.insertDoseLog(DataMappers.doseLogToTable(log));
      debugPrint('[NotificationService] Recorded dose for $medId');

      // 4. Fire Refill Alert if hit threshold
      if (prediction.daysRemaining == 3 || prediction.daysRemaining == 1 || newStock == 0) {
        await NotificationService.instance.showNow(
          id: medId.hashCode + 999,
          title: '⚠️ Refill Reminder: ${med.name}',
          body: prediction.message,
          channelId: NotificationChannels.refillAlerts,
        );
      }
    }
  } else if (actionId == 'skip') {
    final log = DoseLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      medicineId: medId,
      medicineName: 'Unknown', // Ideally we'd fetch it, but skipping is often quick
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

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  FlutterLocalNotificationsPlugin get plugin => _plugin;

  /// Call once before runApp.
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone database
    tz_data.initializeTimeZones();

    // Android init
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

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
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );

    // Create Android notification channels
    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
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
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final granted = await androidPlugin?.requestNotificationsPermission();
      return granted ?? false;
    } else if (Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
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
  /// scheduled reminders). No-op on iOS.
  Future<bool> requestExactAlarmsPermission() async {
    if (!Platform.isAndroid) return true;
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final granted = await androidPlugin?.requestExactAlarmsPermission();
    return granted ?? false;
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
    final effectiveChannel = critical ? NotificationChannels.medsCritical : channelId;

    final androidDetails = AndroidNotificationDetails(
      effectiveChannel,
      effectiveChannel == NotificationChannels.medsCritical ? 'Critical Medication Alerts' : 'Medication Reminders',
      importance: critical ? Importance.max : Importance.high,
      priority: critical ? Priority.max : Priority.high,
      category: AndroidNotificationCategory.reminder,
      actions: actions ??
          const [
            AndroidNotificationAction('take', '✅ Take', showsUserInterface: true),
            AndroidNotificationAction('snooze', '⏰ Snooze', showsUserInterface: false),
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

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
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
        AndroidNotificationAction('snooze', '⏰ Snooze', showsUserInterface: false),
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
