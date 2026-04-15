import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meditime/core/storage/hive_boxes.dart';
import 'package:meditime/features/profile/domain/entities/profile.dart';
import 'package:meditime/features/profile/data/models/profile_model.dart';
import 'dart:async';

class ProfileState {
  final Profile? activeProfile;
  final List<Profile> profiles;

  const ProfileState({
    this.activeProfile,
    this.profiles = const [],
  });

  // Getters for legacy compatibility if needed
  String get activeProfileName => activeProfile?.name ?? 'Guest';
  String get initials => activeProfile?.initials ?? 'G';
  List<String> get dependents => activeProfile?.dependents ?? [];
}

class ProfileCubit extends Cubit<ProfileState> {
  final Box<ProfileModel> _profileBox = Hive.box<ProfileModel>(HiveBoxes.profiles);
  StreamSubscription? _boxSubscription;

  ProfileCubit() : super(const ProfileState()) {
    _loadProfiles();
    _boxSubscription = _profileBox.watch().listen((_) {
      _loadProfiles();
    });
  }

  void _loadProfiles() {
    final profiles = _profileBox.values.toList();
    if (profiles.isEmpty) {
      _loadMockProfile();
    } else {
      // For now, assume the first profile is active
      emit(ProfileState(
        activeProfile: profiles.first,
        profiles: profiles,
      ));
    }
  }

  void _loadMockProfile() {
    const defaultProfile = ProfileModel(
      id: 'default',
      name: 'Rafiq (me)',
      initials: 'RA',
      dependents: ['Mum', 'Son'],
    );
    _profileBox.put(defaultProfile.id, defaultProfile);
  }

  void switchProfile(String id) {
    final profile = _profileBox.get(id);
    if (profile != null) {
      emit(ProfileState(
        activeProfile: profile,
        profiles: state.profiles,
      ));
    }
  }

  @override
  Future<void> close() {
    _boxSubscription?.cancel();
    return super.close();
  }
}
