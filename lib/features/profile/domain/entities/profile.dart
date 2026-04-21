import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String name;
  final String initials;
  final int? age;
  final String? gender;
  final List<String> dependents;

  const Profile({
    required this.id,
    required this.name,
    required this.initials,
    this.age,
    this.gender,
    this.dependents = const [],
  });

  @override
  List<Object?> get props => [id, name, initials, age, gender, dependents];
}
