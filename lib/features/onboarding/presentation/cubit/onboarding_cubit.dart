import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingState extends Equatable {
  final bool hasCompletedOnboarding;
  final String? userName;
  final String? healthGoal;
  final bool isPremium;

  const OnboardingState({
    this.hasCompletedOnboarding = false,
    this.userName,
    this.healthGoal,
    this.isPremium = false,
  });

  OnboardingState copyWith({
    bool? hasCompletedOnboarding,
    String? userName,
    String? healthGoal,
    bool? isPremium,
  }) {
    return OnboardingState(
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      userName: userName ?? this.userName,
      healthGoal: healthGoal ?? this.healthGoal,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  @override
  List<Object?> get props => [hasCompletedOnboarding, userName, healthGoal, isPremium];
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void updateUserInfo({String? name, String? goal}) {
    emit(state.copyWith(userName: name, healthGoal: goal));
  }

  void setPremium(bool isPremium) {
    emit(state.copyWith(isPremium: isPremium));
  }

  void completeOnboarding() {
    emit(state.copyWith(hasCompletedOnboarding: true));
  }
}
