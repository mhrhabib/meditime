// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose_event_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoseEventModelAdapter extends TypeAdapter<DoseEventModel> {
  @override
  final int typeId = 1;

  @override
  DoseEventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoseEventModel(
      id: fields[0] as String,
      medicineId: fields[1] as String,
      scheduledTime: fields[2] as DateTime,
      actualTime: fields[3] as DateTime?,
      status: fields[4] as DoseStatus,
      missedReason: fields[5] as String?,
      note: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DoseEventModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.medicineId)
      ..writeByte(2)
      ..write(obj.scheduledTime)
      ..writeByte(3)
      ..write(obj.actualTime)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.missedReason)
      ..writeByte(6)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoseEventModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
