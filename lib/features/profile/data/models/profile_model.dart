import 'package:hive/hive.dart';
import '../../domain/entities/profile.dart';
import '../../../../core/storage/hive_type_ids.dart';

part 'profile_model.g.dart';

@HiveType(typeId: HiveTypeIds.profile)
class ProfileModel extends Profile {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final String initials;

  @HiveField(3)
  @override
  final List<String> dependents;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.initials,
    this.dependents = const [],
  }) : super(
          id: id,
          name: name,
          initials: initials,
          dependents: dependents,
        );

  factory ProfileModel.fromEntity(Profile entity) {
    return ProfileModel(
      id: entity.id,
      name: entity.name,
      initials: entity.initials,
      dependents: entity.dependents,
    );
  }
}
