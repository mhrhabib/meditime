import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/core/device/device_preferences.dart';
import 'package:meditime/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:meditime/features/profile/domain/entities/profile.dart';
import 'package:meditime/features/profile/domain/repositories/profile_repository.dart';
import 'package:uuid/uuid.dart';

class ProfileState {
  final Profile? activeProfile;
  final List<Profile> profiles;
  final bool needsMainUserSelection;

  const ProfileState({
    this.activeProfile,
    this.profiles = const [],
    this.needsMainUserSelection = false,
  });

  String get activeProfileName => activeProfile?.name ?? 'Guest';
  String get initials => activeProfile?.initials ?? 'G';
  List<String> get dependents => activeProfile?.dependents ?? [];

  ProfileState copyWith({
    Profile? activeProfile,
    List<Profile>? profiles,
    bool? needsMainUserSelection,
  }) {
    return ProfileState(
      activeProfile: activeProfile ?? this.activeProfile,
      profiles: profiles ?? this.profiles,
      needsMainUserSelection:
          needsMainUserSelection ?? this.needsMainUserSelection,
    );
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repo;
  StreamSubscription? _sub;
  String? _persistedId;

  ProfileCubit({ProfileRepository? repo})
      : _repo = repo ?? ProfileRepositoryImpl.instance,
        super(const ProfileState()) {
    _init();
    _sub = _repo.watchAll().listen(_onProfiles);
  }

  Future<void> _init() async {
    _persistedId = await DevicePreferences.getDefaultProfileId();
  }

  void _onProfiles(List<Profile> profiles) {
    if (profiles.isEmpty) {
      emit(const ProfileState());
      return;
    }

    // Determine if we need to show the selection screen
    bool needsSelection = false;
    String? activeId = state.activeProfile?.id ?? _persistedId;

    if (_persistedId == null) {
      if (profiles.length == 1) {
        // Auto-select if only one profile exists
        activeId = profiles.first.id;
        setMainUser(activeId); // Persists it
      } else {
        needsSelection = true;
      }
    }

    final active = profiles.firstWhere(
      (p) => p.id == activeId,
      orElse: () => profiles.first,
    );

    emit(state.copyWith(
      activeProfile: active,
      profiles: profiles,
      needsMainUserSelection: needsSelection,
    ));
  }

  Future<void> addProfile(
    String name, {
    int? age,
    String? gender,
  }) async {
    final id = const Uuid().v4();
    final initials = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'P';
    await _repo.upsert(Profile(
      id: id,
      name: name,
      initials: initials,
      age: age,
      gender: gender,
    ));
  }

  Future<void> switchProfile(String id) async {
    final profiles = await _repo.getAll();
    if (profiles.isEmpty) return;
    final active = profiles.firstWhere((p) => p.id == id,
        orElse: () => profiles.first);
    emit(state.copyWith(activeProfile: active));
  }

  Future<void> setMainUser(String id) async {
    await DevicePreferences.setDefaultProfileId(id);
    _persistedId = id;
    
    final profiles = await _repo.getAll();
    final matches = profiles.where((p) => p.id == id);
    final active = matches.isNotEmpty
        ? matches.first
        : (profiles.isNotEmpty ? profiles.first : null);
        
    emit(state.copyWith(
      activeProfile: active,
      needsMainUserSelection: false,
    ));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
