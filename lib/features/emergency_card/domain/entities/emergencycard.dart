import 'package:equatable/equatable.dart';

class EmergencyCard extends Equatable {
  final String fullName;
  final String bloodType;
  final String allergies;
  final String conditions;
  final String emergencyContactName;
  final String emergencyContactPhone;

  const EmergencyCard({
    required this.fullName,
    required this.bloodType,
    this.allergies = '',
    this.conditions = '',
    required this.emergencyContactName,
    required this.emergencyContactPhone,
  });

  @override
  List<Object?> get props => [
        fullName,
        bloodType,
        allergies,
        conditions,
        emergencyContactName,
        emergencyContactPhone,
      ];
}
