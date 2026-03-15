import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileState {
  final String activeProfileName;
  final String initials;
  final List<String> dependents;

  const ProfileState({
    this.activeProfileName = 'Rafiq (me)',
    this.initials = 'RA',
    this.dependents = const ['Mum', 'Son'],
  });
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void switchProfile(String name, String init) {
    emit(ProfileState(
      activeProfileName: name,
      initials: init,
      dependents: state.dependents,
    ));
  }
}
