import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kOnboardingComplete = 'has_completed_onboarding';
const _kUserName = 'user_name';
const _kUserAge = 'user_age';
const _kUserGender = 'user_gender';
const _kConditions = 'user_conditions';
const _kNotificationsEnabled = 'notifications_enabled';
const _kHealthGoal = 'health_goal';
const _kIsPremium = 'is_premium';

class OnboardingState extends Equatable {
  final bool isLoaded;
  final bool hasCompletedOnboarding;
  final String? userName;
  final int? userAge;
  final String? userGender;
  final List<String> conditions;
  final bool notificationsEnabled;
  final String? healthGoal;
  final bool isPremium;

  const OnboardingState({
    this.isLoaded = false,
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
    bool? isLoaded,
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
      isLoaded: isLoaded ?? this.isLoaded,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
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
        isLoaded,
        hasCompletedOnboarding,
        userName,
        userAge,
        userGender,
        conditions,
        notificationsEnabled,
        healthGoal,
        isPremium,
      ];
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    emit(OnboardingState(
      isLoaded: true,
      hasCompletedOnboarding: prefs.getBool(_kOnboardingComplete) ?? false,
      userName: prefs.getString(_kUserName),
      userAge: prefs.getInt(_kUserAge),
      userGender: prefs.getString(_kUserGender),
      conditions: prefs.getStringList(_kConditions) ?? const [],
      notificationsEnabled: prefs.getBool(_kNotificationsEnabled) ?? false,
      healthGoal: prefs.getString(_kHealthGoal),
      isPremium: prefs.getBool(_kIsPremium) ?? false,
    ));
  }

  Future<void> saveUserInfo({
    required String name,
    required int age,
    required String gender,
  }) async {
    emit(state.copyWith(userName: name, userAge: age, userGender: gender));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserName, name);
    await prefs.setInt(_kUserAge, age);
    await prefs.setString(_kUserGender, gender);
  }

  Future<void> saveConditions(List<String> conditions) async {
    emit(state.copyWith(conditions: conditions));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kConditions, conditions);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    emit(state.copyWith(notificationsEnabled: enabled));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotificationsEnabled, enabled);
  }

  Future<void> setHealthGoal(String goal) async {
    emit(state.copyWith(healthGoal: goal));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kHealthGoal, goal);
  }

  Future<void> setPremium(bool isPremium) async {
    emit(state.copyWith(isPremium: isPremium));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsPremium, isPremium);
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingComplete, true);
    emit(state.copyWith(hasCompletedOnboarding: true));
  }
}
