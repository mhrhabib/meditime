import 'package:hive/hive.dart';
import '../../domain/entities/reminder_settings.dart';
import '../../../../core/storage/hive_type_ids.dart';

part 'reminder_settings_model.g.dart';

@HiveType(typeId: HiveTypeIds.reminderSettings)
class ReminderSettingsModel extends ReminderSettings {
  @HiveField(0)
  @override
  final bool enableNotifications;

  @HiveField(1)
  @override
  final int snoozeDurationMinutes;

  @HiveField(2)
  @override
  final String notificationSound;

  @HiveField(3)
  @override
  final bool criticalAlerts;

  const ReminderSettingsModel({
    this.enableNotifications = true,
    this.snoozeDurationMinutes = 10,
    this.notificationSound = 'default',
    this.criticalAlerts = false,
  }) : super(
          enableNotifications: enableNotifications,
          snoozeDurationMinutes: snoozeDurationMinutes,
          notificationSound: notificationSound,
          criticalAlerts: criticalAlerts,
        );

  factory ReminderSettingsModel.fromEntity(ReminderSettings entity) {
    return ReminderSettingsModel(
      enableNotifications: entity.enableNotifications,
      snoozeDurationMinutes: entity.snoozeDurationMinutes,
      notificationSound: entity.notificationSound,
      criticalAlerts: entity.criticalAlerts,
    );
  }
}
