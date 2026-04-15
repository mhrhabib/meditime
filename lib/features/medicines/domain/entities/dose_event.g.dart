// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoseStatusAdapter extends TypeAdapter<DoseStatus> {
  @override
  final int typeId = 10;

  @override
  DoseStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DoseStatus.taken;
      case 1:
        return DoseStatus.missed;
      case 2:
        return DoseStatus.skipped;
      case 3:
        return DoseStatus.snoozed;
      default:
        return DoseStatus.taken;
    }
  }

  @override
  void write(BinaryWriter writer, DoseStatus obj) {
    switch (obj) {
      case DoseStatus.taken:
        writer.writeByte(0);
        break;
      case DoseStatus.missed:
        writer.writeByte(1);
        break;
      case DoseStatus.skipped:
        writer.writeByte(2);
        break;
      case DoseStatus.snoozed:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoseStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
