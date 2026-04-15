import 'package:equatable/equatable.dart';

class ReminderSettings extends Equatable {
  final bool enableNotifications;
  final int snoozeDurationMinutes;
  final String notificationSound;
  final bool criticalAlerts;

  const ReminderSettings({
    this.enableNotifications = true,
    this.snoozeDurationMinutes = 10,
    this.notificationSound = 'default',
    this.criticalAlerts = false,
  });

  @override
  List<Object?> get props => [
        enableNotifications,
        snoozeDurationMinutes,
        notificationSound,
        criticalAlerts,
      ];
}
