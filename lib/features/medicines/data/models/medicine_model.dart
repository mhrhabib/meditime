import 'package:hive/hive.dart';
import '../../domain/entities/medicine.dart';
import '../../../../core/storage/hive_type_ids.dart';

part 'medicine_model.g.dart';

@HiveType(typeId: HiveTypeIds.medicine)
class MedicineModel extends Medicine {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String type;

  @HiveField(3)
  @override
  final String schedule;

  @HiveField(4)
  @override
  final int stockRemaining;

  @HiveField(5)
  @override
  final int stockTotal;

  @HiveField(6)
  @override
  final int daysLeft;

  @HiveField(7)
  @override
  final bool isLowStock;

  const MedicineModel({
    required this.id,
    required this.name,
    required this.type,
    required this.schedule,
    required this.stockRemaining,
    required this.stockTotal,
    required this.daysLeft,
    required this.isLowStock,
  }) : super(
          id: id,
          name: name,
          type: type,
          schedule: schedule,
          stockRemaining: stockRemaining,
          stockTotal: stockTotal,
          daysLeft: daysLeft,
          isLowStock: isLowStock,
        );

  factory MedicineModel.fromEntity(Medicine entity) {
    return MedicineModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      schedule: entity.schedule,
      stockRemaining: entity.stockRemaining,
      stockTotal: entity.stockTotal,
      daysLeft: entity.daysLeft,
      isLowStock: entity.isLowStock,
    );
  }
}
