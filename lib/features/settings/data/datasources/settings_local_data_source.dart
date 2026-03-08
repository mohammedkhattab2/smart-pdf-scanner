import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings_model.dart';

abstract class SettingsLocalDataSource {
  /// Get settings from local storage
  Future<AppSettingsModel?> getSettings();
  
  /// Save settings to local storage
  Future<void> saveSettings(AppSettingsModel settings);
  
  /// Clear all settings
  Future<void> clearSettings();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _settingsKey = 'app_settings';
  final SharedPreferences sharedPreferences;

  const SettingsLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<AppSettingsModel?> getSettings() async {
    final String? settingsString = sharedPreferences.getString(_settingsKey);
    
    if (settingsString != null) {
      try {
        final Map<String, dynamic> settingsJson = json.decode(settingsString);
        return AppSettingsModel.fromJson(settingsJson);
      } catch (e) {
        // If parsing fails, return null to use default settings
        return null;
      }
    }
    
    return null;
  }

  @override
  Future<void> saveSettings(AppSettingsModel settings) async {
    final String settingsString = json.encode(settings.toJson());
    await sharedPreferences.setString(_settingsKey, settingsString);
  }

  @override
  Future<void> clearSettings() async {
    await sharedPreferences.remove(_settingsKey);
  }
}