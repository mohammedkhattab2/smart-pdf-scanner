import '../../domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    super.language = 'en',
    super.theme = 'system',
    super.pdfQuality = 'high',
    super.defaultSavePath,
    super.autoEnhanceImages = true,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      language: json['language'] ?? 'en',
      theme: json['theme'] ?? 'system',
      pdfQuality: json['pdfQuality'] ?? 'high',
      defaultSavePath: json['defaultSavePath'],
      autoEnhanceImages: json['autoEnhanceImages'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'theme': theme,
      'pdfQuality': pdfQuality,
      'defaultSavePath': defaultSavePath,
      'autoEnhanceImages': autoEnhanceImages,
    };
  }

  factory AppSettingsModel.fromEntity(AppSettings entity) {
    return AppSettingsModel(
      language: entity.language,
      theme: entity.theme,
      pdfQuality: entity.pdfQuality,
      defaultSavePath: entity.defaultSavePath,
      autoEnhanceImages: entity.autoEnhanceImages,
    );
  }

  AppSettings toEntity() => this;

  static const AppSettingsModel defaultSettings = AppSettingsModel();
}