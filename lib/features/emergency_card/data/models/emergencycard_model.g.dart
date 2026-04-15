// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergencycard_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmergencyCardModelAdapter extends TypeAdapter<EmergencyCardModel> {
  @override
  final int typeId = 4;

  @override
  EmergencyCardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmergencyCardModel(
      fullName: fields[0] as String,
      bloodType: fields[1] as String,
      allergies: fields[2] as String,
      conditions: fields[3] as String,
      emergencyContactName: fields[4] as String,
      emergencyContactPhone: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EmergencyCardModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.fullName)
      ..writeByte(1)
      ..write(obj.bloodType)
      ..writeByte(2)
      ..write(obj.allergies)
      ..writeByte(3)
      ..write(obj.conditions)
      ..writeByte(4)
      ..write(obj.emergencyContactName)
      ..writeByte(5)
      ..write(obj.emergencyContactPhone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergencyCardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
