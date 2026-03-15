import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsState {
  final bool soundAndVibration;
  final bool autoRepeat;
  final bool lockScreenNotification;
  final bool allowSnooze;
  final bool quietHoursEnabled;

  const SettingsState({
    this.soundAndVibration = true,
    this.autoRepeat = true,
    this.lockScreenNotification = true,
    this.allowSnooze = true,
    this.quietHoursEnabled = false,
  });

  SettingsState copyWith({
    bool? soundAndVibration,
    bool? autoRepeat,
    bool? lockScreenNotification,
    bool? allowSnooze,
    bool? quietHoursEnabled,
  }) {
    return SettingsState(
      soundAndVibration: soundAndVibration ?? this.soundAndVibration,
      autoRepeat: autoRepeat ?? this.autoRepeat,
      lockScreenNotification: lockScreenNotification ?? this.lockScreenNotification,
      allowSnooze: allowSnooze ?? this.allowSnooze,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleSoundAndVibration(bool value) => emit(state.copyWith(soundAndVibration: value));
  void toggleAutoRepeat(bool value) => emit(state.copyWith(autoRepeat: value));
  void toggleLockScreen(bool value) => emit(state.copyWith(lockScreenNotification: value));
  void toggleSnooze(bool value) => emit(state.copyWith(allowSnooze: value));
  void toggleQuietHours(bool value) => emit(state.copyWith(quietHoursEnabled: value));
}
