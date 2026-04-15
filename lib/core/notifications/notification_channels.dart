import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Android notification channel IDs and definitions.
class NotificationChannels {
  // Channel IDs
  static const String medsDefault = 'meds_default';
  static const String medsCritical = 'meds_critical';
  static const String refillAlerts = 'refill_alerts';
  static const String weeklyInsights = 'weekly_insights';

  /// All channels — register these on Android at startup.
  static List<AndroidNotificationChannel> get all => [
        const AndroidNotificationChannel(
          medsDefault,
          'Medication Reminders',
          description: 'Reminders to take your scheduled medications.',
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
        ),
        const AndroidNotificationChannel(
          medsCritical,
          'Critical Medication Alerts',
          description: 'High-priority reminders that bypass Do Not Disturb.',
          importance: Importance.max,
          enableVibration: true,
          playSound: true,
        ),
        const AndroidNotificationChannel(
          refillAlerts,
          'Refill Alerts',
          description: 'Alerts when your medication stock is running low.',
          importance: Importance.defaultImportance,
          playSound: true,
        ),
        const AndroidNotificationChannel(
          weeklyInsights,
          'Weekly Adherence Insights',
          description: 'Your weekly medication adherence summary.',
          importance: Importance.low,
        ),
      ];
}
