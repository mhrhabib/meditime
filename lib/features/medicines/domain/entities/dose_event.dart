import 'package:equatable/equatable.dart';

enum DoseStatus {
  taken,
  missed,
  skipped,
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
