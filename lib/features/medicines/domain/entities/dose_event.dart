import 'package:equatable/equatable.dart';

/// Derived per-scheduled-slot status. "missed" is a derived state — it has no
/// persisted DoseLog row; we infer it from `scheduledTime + grace < now` and
/// the absence of any taken/skipped log for that slot.
enum DoseEventStatus {
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
  final DoseEventStatus status;
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
