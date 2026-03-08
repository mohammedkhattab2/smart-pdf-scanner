import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_theme_extension.dart';

/// Premium Theme System with Luxurious Colors and Magical Gradients
class AppTheme {
  AppTheme._();

  // Core Luxury Colors tuned to match the app icon (royal purple glass)
  // Deep royal violet as primary brand color
  static const Color primaryColor = Color(0xFF7B3FE4); // Royal Violet
  // Soft neon lavender accent used for highlights and text accents
  static const Color accentColor = Color(0xFFA66CFF); // Neon Lavender
  // Dark purple surface similar to the icon background
  static const Color surfaceColor = Color(0xFF1A102A); // Midnight Purple Surface
  // Almost-black with a subtle purple tint for the global background
  static const Color backgroundColor = Color(0xFF050109); // Cosmic Black Purple
  // Card background with a rich deep violet tint
  static const Color cardColor = Color(0xFF120A1F); // Velvet Purple Card
  
  // Status Colors - Jewel Tones
  static const Color successColor = Color(0xFF50C878); // Emerald
  static const Color errorColor = Color(0xFFDC143C); // Ruby
  static const Color warningColor = Color(0xFFFFA500); // Amber
  static const Color infoColor = Color(0xFF0F52BA); // Sapphire
  
  // Luxury Color Palette aligned with the icon (purple + glass + subtle cyan)
  // Near-black with a very subtle purple undertone
  static const Color obsidianBlack = Color(0xFF050109);
  // Kept as "royalGold" name for backwards compatibility, but now a soft lavender highlight
  static const Color royalGold = Color(0xFFB08CFF); // Soft Lavender Highlight
  // Champagne now a glassy off‑white with a cool tint (for glass surfaces)
  static const Color champagneGold = Color(0xFFF5F3FF); // Crystal White
  // Rose tone shifted towards magenta violet
  static const Color roseGold = Color(0xFFE39BFF); // Magenta Violet
  // Cool platinum for glass edges and strokes
  static const Color platinumSilver = Color(0xFFE6E9F5);
  // Deep purples taken directly from the icon vibe
  static const Color deepAmethyst = Color(0xFF6B3AA8);
  static const Color imperialPurple = Color(0xFF4B2C87);
  // Sapphire is now a cool blue‑cyan used for light streaks
  static const Color midnightSapphire = Color(0xFF2139A8);
  // Emerald shifted slightly towards teal to match subtle cyan reflections
  static const Color emeraldGreen = Color(0xFF27C1A7);
  // Burgundy becomes a rich plum accent
  static const Color burgundy = Color(0xFF5A1248);
  // Iridescent violet for soft glow overlays
  static const Color iridescent = Color(0xFFE0B0FF);
  
  // Jewel Tones (slightly cooled to sit inside the purple identity)
  static const Color rubyRed = Color(0xFFE2466E);
  static const Color sapphireBlue = Color(0xFF315CFF); // Vibrant blue accent
  static const Color emerald = Color(0xFF1EBFA1); // Teal‑emerald
  static const Color amethyst = Color(0xFF9966CC);
  static const Color topaz = Color(0xFFEEBA76);
  static const Color onyx = Color(0xFF262533);
  
  // Metallic Accents (shifted towards cold light + violet metal)
  static const Color metallicGold = Color(0xFFD2BBFF); // Metallic Lavender
  static const Color metallicSilver = Color(0xFFBFC8F2); // Cool Silver
  static const Color metallicBronze = Color(0xFF9E6FE8); // Violet Bronze
  static const Color metallicCopper = Color(0xFF8A5AD8);
  static const Color metallicRoseGold = Color(0xFFCB8CFF);
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Border Radius
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusRound = 999.0;
  
  // Luxury Gradient Definitions – redesigned to mirror the app icon
  // Main brand gradient: deep purple core with neon lavender edge
  static const royalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      deepAmethyst,
      imperialPurple,
      accentColor,
    ],
  );
  
  // Dark background gradient used behind glass cards
  static const obsidianGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF060015),
      obsidianBlack,
      Color(0xFF1A102A),
    ],
  );
  
  // Accent gradient used for important elements like document thumbnail background
  static const imperialGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      deepAmethyst,
      imperialPurple,
      midnightSapphire,
    ],
  );
  
  // Jewel gradient used for subtle glow overlays
  static const jewelGradient = RadialGradient(
    center: Alignment.center,
    radius: 1.0,
    colors: [
      sapphireBlue, // cyan/blue highlight
      emerald,      // teal highlight
      amethyst,     // soft violet
      rubyRed,      // magenta accent
    ],
  );
  
  // Metallic gradient used for strokes and premium dividers
  static const metallicGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      metallicSilver,
      metallicGold,
      metallicRoseGold,
    ],
  );
  
  static const diamondGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFE5E5E5),
      Color(0xFFCCCCCC),
      Color(0xFFE5E5E5),
      Color(0xFFFFFFFF),
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  );
  
  static const luxuryDarkGradient = RadialGradient(
    center: Alignment.center,
    radius: 2.0,
    colors: [
      Color(0xFF1A1A1A),
      Color(0xFF0F0F0F),
      Color(0xFF000000),
    ],
  );

  // Glass Gradients
  static const glassGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1A000000),
      Color(0x0D000000),
    ],
  );
  
  static const glassGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AFFFFFF),
      Color(0x0DFFFFFF),
    ],
  );
  
  // Magical Gradients
  // Velvet now a deep royal purple velvet, used sparingly for CTAs
  static const velvetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      imperialPurple,
      deepAmethyst,
      Color(0xFF2B143F),
    ],
  );
  
  static const iridescentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      iridescent,
      Color(0xFFC5B2FF),
      Color(0xFFE6E6FA),
      iridescent,
    ],
  );
  
  // Aurora Luxury Gradients – subtle violet + cyan light sweeps
  static const auroraLuxuryLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x26A66CFF), // Lavender shimmer
      Color(0x26315CFF), // Blue highlight
      Color(0x261EBFA1), // Teal highlight
      Color(0x26A66CFF),
    ],
  );

  static const auroraLuxuryDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x3321304F), // Deep violet glow
      Color(0x33315CFF), // Sapphire glow
      Color(0x331EBFA1), // Teal glow
      Color(0x3321304F),
    ],
  );

  // Glass Morphism Effect
  static BoxDecoration glassDecoration({
    BorderRadius? borderRadius,
    List<Color>? gradientColors,
  }) {
    return BoxDecoration(
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors ?? [
          Colors.white.withValues(alpha:  0.1),
          Colors.white.withValues(alpha: 0.05),
        ],
      ),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  // Luxury Shadows – violet glow instead of gold
  static List<BoxShadow> luxuryShadow = [
    BoxShadow(
      color: accentColor.withValues(alpha: 0.35),
      blurRadius: 40,
      offset: const Offset(0, 15),
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.6),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> goldGlowShadow = [
    BoxShadow(
      color: accentColor.withValues(alpha: 0.55),
      blurRadius: 30,
      offset: Offset.zero,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: sapphireBlue.withValues(alpha: 0.25),
      blurRadius: 60,
      offset: Offset.zero,
      spreadRadius: 10,
    ),
  ];

  static List<BoxShadow> subtleLuxuryShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 15,
      offset: const Offset(0, 8),
    ),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: deepAmethyst,
        tertiary: emerald,
        surface: Color(0xFFF5F0FF), // Light purple-tinted surface
        error: rubyRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: obsidianBlack,
      ),
      scaffoldBackgroundColor: Color(0xFFFDFCFF), // Nearly white with purple tint
      extensions: [
        AppThemeExtension(
          accentColor: accentColor,
          successColor: emerald,
          errorColor: rubyRed,
          warningColor: topaz,
          infoColor: sapphireBlue,
          premiumGradient: royalGradient,
          glassGradient: glassGradientLight,
          magicalGradient: imperialGradient,
          auroraGradient: auroraLuxuryLight,
        ),
      ],
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: obsidianBlack,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 12,
        extendedTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: Colors.white,
        surfaceTintColor: primaryColor.withValues(alpha: 0.05),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: obsidianBlack,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: obsidianBlack,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: obsidianBlack,
        ),
        headlineLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: obsidianBlack,
        ),
        headlineMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: obsidianBlack,
        ),
        headlineSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: obsidianBlack,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: obsidianBlack,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: obsidianBlack,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: deepAmethyst,
        tertiary: emerald,
        surface: surfaceColor,
        error: rubyRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white.withValues(alpha: 0.95),
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.black,
        elevation: 12,
        extendedTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: cardColor,
        surfaceTintColor: accentColor.withValues(alpha: 0.05),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
        headlineLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
    );
  }
}