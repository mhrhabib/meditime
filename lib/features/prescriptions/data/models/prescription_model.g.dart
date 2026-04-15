// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrescriptionModelAdapter extends TypeAdapter<PrescriptionModel> {
  @override
  final int typeId = 3;

  @override
  PrescriptionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrescriptionModel(
      id: fields[0] as String,
      doctorName: fields[1] as String,
      date: fields[2] as DateTime,
      reason: fields[3] as String,
      imageUrl: fields[4] as String?,
      medicines: (fields[5] as List).cast<String>(),
      isScanned: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PrescriptionModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.doctorName)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.reason)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.medicines)
      ..writeByte(6)
      ..write(obj.isScanned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescriptionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
