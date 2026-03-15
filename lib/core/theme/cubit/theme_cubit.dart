import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ThemeModeOption { system, light, dark }

class ThemeState {
  final ThemeModeOption themeModeOption;
  const ThemeState({required this.themeModeOption});
  
  ThemeMode get themeMode {
    switch (themeModeOption) {
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
      case ThemeModeOption.system:
        return ThemeMode.system;
    }
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeModeOption: ThemeModeOption.system));

  void updateTheme(ThemeModeOption option) {
    emit(ThemeState(themeModeOption: option));
  }
}
