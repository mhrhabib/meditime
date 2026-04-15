import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'dose_event.g.dart';

@HiveType(typeId: 10) // Unique ID for this enum
enum DoseStatus {
  @HiveField(0)
  taken,
  @HiveField(1)
  missed,
  @HiveField(2)
  skipped,
  @HiveField(3)
  snoozed
}

class DoseEvent extends Equatable {
  final String id;
  final String medicineId;
  final DateTime scheduledTime;
  final DateTime? actualTime;
  final DoseStatus status;
  final String? missedReason;
  final String? note;

  const DoseEvent({
    required this.id,
    required this.medicineId,
    required this.scheduledTime,
    this.actualTime,
    required this.status,
    this.missedReason,
    this.note,
  });

  @override
  List<Object?> get props => [
        id,
        medicineId,
        scheduledTime,
        actualTime,
        status,
        missedReason,
        note,
      ];
}
