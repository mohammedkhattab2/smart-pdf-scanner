import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppThemeState {
  final ThemeMode themeMode;

  const AppThemeState({required this.themeMode});
}

class AppThemeCubit extends Cubit<AppThemeState> {
  AppThemeCubit() : super(const AppThemeState(themeMode: ThemeMode.system));

  void setThemeMode(ThemeMode mode) {
    emit(AppThemeState(themeMode: mode));
  }

  void setThemeFromString(String theme) {
    final ThemeMode mode;
    switch (theme) {
      case 'light':
        mode = ThemeMode.light;
        break;
      case 'dark':
        mode = ThemeMode.dark;
        break;
      default:
        mode = ThemeMode.system;
    }
    setThemeMode(mode);
  }
}