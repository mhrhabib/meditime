import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String name;
  final String initials;
  final List<String> dependents;

  const Profile({
    required this.id,
    required this.name,
    required this.initials,
    this.dependents = const [],
  });

  @override
  List<Object?> get props => [id, name, initials, dependents];
}
