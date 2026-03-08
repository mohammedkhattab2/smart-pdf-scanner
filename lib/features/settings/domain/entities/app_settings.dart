class AppSettings {
  final String language;
  final String theme;
  final String pdfQuality;
  final String? defaultSavePath;
  final bool autoEnhanceImages;

  const AppSettings({
    this.language = 'en',
    this.theme = 'system',
    this.pdfQuality = 'high',
    this.defaultSavePath,
    this.autoEnhanceImages = true,
  });

  AppSettings copyWith({
    String? language,
    String? theme,
    String? pdfQuality,
    String? defaultSavePath,
    bool? autoEnhanceImages,
  }) {
    return AppSettings(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      pdfQuality: pdfQuality ?? this.pdfQuality,
      defaultSavePath: defaultSavePath ?? this.defaultSavePath,
      autoEnhanceImages: autoEnhanceImages ?? this.autoEnhanceImages,
    );
  }
}