import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/save_settings_usecase.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase getSettings;
  final SaveSettingsUseCase saveSettings;

  SettingsCubit({
    required this.getSettings,
    required this.saveSettings,
  }) : super(SettingsInitial());

  AppSettings? _currentSettings;
  String? _appVersion;

  AppSettings? get currentSettings => _currentSettings;
  String? get appVersion => _appVersion;

  Future<void> loadSettings() async {
    emit(SettingsLoading());

    final result = await getSettings();
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settings) {
        _currentSettings = settings;
        emit(SettingsLoaded(settings));
      },
    );
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    emit(SettingsLoading());
    
    final result = await saveSettings(newSettings);
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) {
        _currentSettings = newSettings;
        emit(SettingsUpdated(
          settings: newSettings,
          message: 'Settings saved successfully',
        ));
      },
    );
  }

  void updateLanguage(String language) {
    if (_currentSettings != null) {
      final newSettings = _currentSettings!.copyWith(language: language);
      updateSettings(newSettings);
    }
  }

  void updateTheme(String theme) {
    if (_currentSettings != null) {
      final newSettings = _currentSettings!.copyWith(theme: theme);
      updateSettings(newSettings);
    }
  }

  void updatePdfQuality(String quality) {
    if (_currentSettings != null) {
      final newSettings = _currentSettings!.copyWith(pdfQuality: quality);
      updateSettings(newSettings);
    }
  }

  void updateDefaultSavePath(String? path) {
    if (_currentSettings != null) {
      final newSettings = _currentSettings!.copyWith(defaultSavePath: path);
      updateSettings(newSettings);
    }
  }

  void toggleAutoEnhance() {
    if (_currentSettings != null) {
      final newSettings = _currentSettings!.copyWith(
        autoEnhanceImages: !_currentSettings!.autoEnhanceImages,
      );
      updateSettings(newSettings);
    }
  }

  void setAppVersion(String version) {
    _appVersion = version;
  }
}