import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'notification_channels.dart';

/// Callback for handling notification taps — must be top-level.
@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(NotificationResponse response) {
  // Will be wired to router / dose-event handler later.
  debugPrint('[NotificationService] tapped: ${response.payload}');
}

/// Callback for background notification actions (Take / Snooze / Skip).
@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse response) {
  debugPrint('[NotificationService] background action: ${response.actionId} | ${response.payload}');
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

  /// Cancel all notifications.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
