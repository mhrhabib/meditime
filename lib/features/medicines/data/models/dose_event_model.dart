import 'package:hive/hive.dart';
import '../../domain/entities/dose_event.dart';
import '../../../../core/storage/hive_type_ids.dart';

part 'dose_event_model.g.dart';

@HiveType(typeId: HiveTypeIds.doseEvent)
class DoseEventModel extends DoseEvent {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String medicineId;

  @HiveField(2)
  @override
  final DateTime scheduledTime;

  @HiveField(3)
  @override
  final DateTime? actualTime;

  @HiveField(4)
  @override
  final DoseStatus status;

  @HiveField(5)
  @override
  final String? missedReason;

  @HiveField(6)
  @override
  final String? note;

  const DoseEventModel({
    required this.id,
    required this.medicineId,
    required this.scheduledTime,
    this.actualTime,
    required this.status,
    this.missedReason,
    this.note,
  }) : super(
          id: id,
          medicineId: medicineId,
          scheduledTime: scheduledTime,
          actualTime: actualTime,
          status: status,
          missedReason: missedReason,
          note: note,
        );

  factory DoseEventModel.fromEntity(DoseEvent entity) {
    return DoseEventModel(
      id: entity.id,
      medicineId: entity.medicineId,
      scheduledTime: entity.scheduledTime,
      actualTime: entity.actualTime,
      status: entity.status,
      missedReason: entity.missedReason,
      note: entity.note,
    );
  }
}
