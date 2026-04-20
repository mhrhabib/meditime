import 'package:equatable/equatable.dart';

enum DoseStatus { taken, skipped, snoozed }

class DoseLog extends Equatable {
  final String id;
  final String medicineId;
  final String medicineName;
  final DateTime dateTime;
  final DoseStatus status;
  final String? note;

  const DoseLog({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    required this.dateTime,
    required this.status,
    this.note,
  });

  @override
  List<Object?> get props => [id, medicineId, medicineName, dateTime, status, note];
}
