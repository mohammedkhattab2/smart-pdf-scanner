import 'package:flutter/material.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color accentColor;
  final Color successColor;
  final Color errorColor;
  final Color warningColor;
  final Color infoColor;
  final LinearGradient premiumGradient;
  final LinearGradient glassGradient;
  final LinearGradient magicalGradient;
  final LinearGradient auroraGradient;

  const AppThemeExtension({
    required this.accentColor,
    required this.successColor,
    required this.errorColor,
    required this.warningColor,
    required this.infoColor,
    required this.premiumGradient,
    required this.glassGradient,
    required this.magicalGradient,
    required this.auroraGradient,
  });
  
  // Luxury gradient getters for easy access
  LinearGradient get royalGradient => premiumGradient;
  LinearGradient get imperialGradient => magicalGradient;
  LinearGradient get auroraLuxury => auroraGradient;

  @override
  AppThemeExtension copyWith({
    Color? accentColor,
    Color? successColor,
    Color? errorColor,
    Color? warningColor,
    Color? infoColor,
    LinearGradient? premiumGradient,
    LinearGradient? glassGradient,
    LinearGradient? magicalGradient,
    LinearGradient? auroraGradient,
  }) {
    return AppThemeExtension(
      accentColor: accentColor ?? this.accentColor,
      successColor: successColor ?? this.successColor,
      errorColor: errorColor ?? this.errorColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
      premiumGradient: premiumGradient ?? this.premiumGradient,
      glassGradient: glassGradient ?? this.glassGradient,
      magicalGradient: magicalGradient ?? this.magicalGradient,
      auroraGradient: auroraGradient ?? this.auroraGradient,
    );
  }

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      successColor: Color.lerp(successColor, other.successColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
      infoColor: Color.lerp(infoColor, other.infoColor, t)!,
      premiumGradient: LinearGradient.lerp(premiumGradient, other.premiumGradient, t)!,
      glassGradient: LinearGradient.lerp(glassGradient, other.glassGradient, t)!,
      magicalGradient: LinearGradient.lerp(magicalGradient, other.magicalGradient, t)!,
      auroraGradient: LinearGradient.lerp(auroraGradient, other.auroraGradient, t) ?? auroraGradient,
    );
  }
}

extension AppThemeExtensionX on BuildContext {
  AppThemeExtension get appTheme => Theme.of(this).extension<AppThemeExtension>()!;
}