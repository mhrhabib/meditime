import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kOnboardingComplete = 'has_completed_onboarding';

class OnboardingState extends Equatable {
  final bool hasCompletedOnboarding;
  final String? userName;
  final int? userAge;
  final String? userGender;
  final List<String> conditions;
  final bool notificationsEnabled;
  final String? healthGoal;
  final bool isPremium;

  const OnboardingState({
    this.hasCompletedOnboarding = false,
    this.userName,
    this.userAge,
    this.userGender,
    this.conditions = const [],
    this.notificationsEnabled = false,
    this.healthGoal,
    this.isPremium = false,
  });

  OnboardingState copyWith({
    bool? hasCompletedOnboarding,
    String? userName,
    int? userAge,
    String? userGender,
    List<String>? conditions,
    bool? notificationsEnabled,
    String? healthGoal,
    bool? isPremium,
  }) {
    return OnboardingState(
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      userName: userName ?? this.userName,
      userAge: userAge ?? this.userAge,
      userGender: userGender ?? this.userGender,
      conditions: conditions ?? this.conditions,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      healthGoal: healthGoal ?? this.healthGoal,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  @override
  List<Object?> get props => [
        hasCompletedOnboarding,
        userName,
        userAge,
        userGender,
        conditions,
        notificationsEnabled,
        healthGoal,
        isPremium
      ];
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState()) {
    _loadOnboardingState();
  }

  Future<void> _loadOnboardingState() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool(_kOnboardingComplete) ?? false;
    if (completed) {
      emit(state.copyWith(hasCompletedOnboarding: true));
    }
  }

  void updateUserInfo({String? name, int? age, String? gender, String? goal}) {
    emit(state.copyWith(
      userName: name,
      userAge: age,
      userGender: gender,
      healthGoal: goal,
    ));
  }

  void saveUserInfo({required String name, required int age, required String gender}) {
    emit(state.copyWith(userName: name, userAge: age, userGender: gender));
  }

  void saveConditions(List<String> conditions) {
    emit(state.copyWith(conditions: conditions));
  }

  void setNotificationsEnabled(bool enabled) {
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  void setPremium(bool isPremium) {
    emit(state.copyWith(isPremium: isPremium));
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingComplete, true);
    emit(state.copyWith(hasCompletedOnboarding: true));
  }
}
