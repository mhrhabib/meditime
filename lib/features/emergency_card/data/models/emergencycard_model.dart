import 'package:hive/hive.dart';
import '../../domain/entities/emergencycard.dart';
import '../../../../core/storage/hive_type_ids.dart';

part 'emergencycard_model.g.dart';

@HiveType(typeId: HiveTypeIds.emergencyCard)
class EmergencyCardModel extends EmergencyCard {
  @HiveField(0)
  @override
  final String fullName;

  @HiveField(1)
  @override
  final String bloodType;

  @HiveField(2)
  @override
  final String allergies;

  @HiveField(3)
  @override
  final String conditions;

  @HiveField(4)
  @override
  final String emergencyContactName;

  @HiveField(5)
  @override
  final String emergencyContactPhone;

  const EmergencyCardModel({
    required this.fullName,
    required this.bloodType,
    this.allergies = '',
    this.conditions = '',
    required this.emergencyContactName,
    required this.emergencyContactPhone,
  }) : super(
          fullName: fullName,
          bloodType: bloodType,
          allergies: allergies,
          conditions: conditions,
          emergencyContactName: emergencyContactName,
          emergencyContactPhone: emergencyContactPhone,
        );

  factory EmergencyCardModel.fromEntity(EmergencyCard entity) {
    return EmergencyCardModel(
      fullName: entity.fullName,
      bloodType: entity.bloodType,
      allergies: entity.allergies,
      conditions: entity.conditions,
      emergencyContactName: entity.emergencyContactName,
      emergencyContactPhone: entity.emergencyContactPhone,
    );
  }
}
