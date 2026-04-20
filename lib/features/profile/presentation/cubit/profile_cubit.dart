import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:meditime/features/profile/domain/entities/profile.dart';
import 'package:meditime/features/profile/domain/repositories/profile_repository.dart';

class ProfileState {
  final Profile? activeProfile;
  final List<Profile> profiles;

  const ProfileState({
    this.activeProfile,
    this.profiles = const [],
  });

  String get activeProfileName => activeProfile?.name ?? 'Guest';
  String get initials => activeProfile?.initials ?? 'G';
  List<String> get dependents => activeProfile?.dependents ?? [];
}

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repo;
  StreamSubscription? _sub;

  ProfileCubit({ProfileRepository? repo})
      : _repo = repo ?? ProfileRepositoryImpl.instance,
        super(const ProfileState()) {
    _sub = _repo.watchAll().listen(_onProfiles);
  }

  void _onProfiles(List<Profile> profiles) {
    if (profiles.isEmpty) {
      emit(const ProfileState());
      return;
    }
    final activeId = state.activeProfile?.id ?? profiles.first.id;
    final active = profiles.firstWhere((p) => p.id == activeId,
        orElse: () => profiles.first);
    emit(ProfileState(activeProfile: active, profiles: profiles));
  }

  Future<void> addProfile(String name) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final initials = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'P';
    await _repo.upsert(Profile(id: id, name: name, initials: initials));
  }

  Future<void> switchProfile(String id) async {
    final profiles = await _repo.getAll();
    if (profiles.isEmpty) return;
    final active = profiles.firstWhere((p) => p.id == id,
        orElse: () => profiles.first);
    emit(ProfileState(activeProfile: active, profiles: profiles));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
