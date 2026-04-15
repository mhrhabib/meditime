import 'package:hive/hive.dart';
import '../../domain/entities/prescription.dart';
import '../../../../core/storage/hive_type_ids.dart';

part 'prescription_model.g.dart';

@HiveType(typeId: HiveTypeIds.prescription)
class PrescriptionModel extends Prescription {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String doctorName;

  @HiveField(2)
  @override
  final DateTime date;

  @HiveField(3)
  @override
  final String reason;

  @HiveField(4)
  @override
  final String? imageUrl;

  @HiveField(5)
  @override
  final List<String> medicines;

  @HiveField(6)
  @override
  final bool isScanned;

  const PrescriptionModel({
    required this.id,
    required this.doctorName,
    required this.date,
    required this.reason,
    this.imageUrl,
    this.medicines = const [],
    this.isScanned = false,
  }) : super(
          id: id,
          doctorName: doctorName,
          date: date,
          reason: reason,
          imageUrl: imageUrl,
          medicines: medicines,
          isScanned: isScanned,
        );

  factory PrescriptionModel.fromEntity(Prescription entity) {
    return PrescriptionModel(
      id: entity.id,
      doctorName: entity.doctorName,
      date: entity.date,
      reason: entity.reason,
      imageUrl: entity.imageUrl,
      medicines: entity.medicines,
      isScanned: entity.isScanned,
    );
  }
}
