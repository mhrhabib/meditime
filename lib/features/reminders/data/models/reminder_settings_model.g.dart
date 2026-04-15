// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderSettingsModelAdapter extends TypeAdapter<ReminderSettingsModel> {
  @override
  final int typeId = 5;

  @override
  ReminderSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderSettingsModel(
      enableNotifications: fields[0] as bool,
      snoozeDurationMinutes: fields[1] as int,
      notificationSound: fields[2] as String,
      criticalAlerts: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderSettingsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.enableNotifications)
      ..writeByte(1)
      ..write(obj.snoozeDurationMinutes)
      ..writeByte(2)
      ..write(obj.notificationSound)
      ..writeByte(3)
      ..write(obj.criticalAlerts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
