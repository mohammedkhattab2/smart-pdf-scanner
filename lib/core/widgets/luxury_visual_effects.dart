import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Luxury Shimmer Effect Widget (Static)
class LuxuryShimmerEffect extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;
  final double opacity;

  const LuxuryShimmerEffect({
    super.key,
    required this.child,
    this.gradient,
    this.opacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return (gradient ?? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.transparent,
                  AppTheme.champagneGold.withValues(alpha: opacity),
                  AppTheme.platinumSilver.withValues(alpha: opacity),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 0.6, 1.0],
              )).createShader(bounds);
            },
            blendMode: BlendMode.srcOver,
            child: Container(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

/// Luxury Glow Effect
class LuxuryGlowEffect extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double intensity;
  final double spread;

  const LuxuryGlowEffect({
    super.key,
    required this.child,
    this.glowColor = const Color(0xFFD4AF37),
    this.intensity = 0.5,
    this.spread = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: intensity * 0.5),
            blurRadius: spread,
            spreadRadius: spread * 0.3,
          ),
          BoxShadow(
            color: glowColor.withValues(alpha: intensity * 0.3),
            blurRadius: spread * 1.5,
            spreadRadius: spread * 0.5,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Metallic Surface Effect
class MetallicSurface extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color baseColor;
  final double intensity;

  const MetallicSurface({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.baseColor = const Color(0xFFD4AF37),
    this.intensity = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HSLColor.fromColor(baseColor)
                .withLightness((HSLColor.fromColor(baseColor).lightness + 0.3).clamp(0.0, 1.0))
                .toColor(),
            baseColor,
            HSLColor.fromColor(baseColor)
                .withLightness(HSLColor.fromColor(baseColor).lightness * 0.7)
                .toColor(),
            baseColor,
            HSLColor.fromColor(baseColor)
                .withLightness((HSLColor.fromColor(baseColor).lightness + 0.2).clamp(0.0, 1.0))
                .toColor(),
          ],
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}

/// Velvet Texture Background
class VelvetBackground extends StatelessWidget {
  final Widget child;
  final Color baseColor;
  final double opacity;

  const VelvetBackground({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFF800020),
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                baseColor.withValues(alpha: opacity),
                baseColor.withValues(alpha: opacity * 0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Noise texture overlay
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: NoiseTexturePainter(
            color: baseColor,
            opacity: opacity * 0.3,
          ),
        ),
        child,
      ],
    );
  }
}

/// Noise Texture Painter for subtle texture effects
class NoiseTexturePainter extends CustomPainter {
  final Color color;
  final double opacity;

  NoiseTexturePainter({
    required this.color,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    // Create noise pattern
    const dotSize = 1.0;
    const spacing = 3.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // Add some randomness to position and opacity
        final offsetX = (x.hashCode % 3 - 1) * 0.5;
        final offsetY = (y.hashCode % 3 - 1) * 0.5;
        final dotOpacity = ((x + y).hashCode % 10) / 10;
        
        paint.color = color.withValues(alpha: opacity * dotOpacity);
        canvas.drawCircle(
          Offset(x + offsetX, y + offsetY),
          dotSize,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Iridescent Effect
class IridescentSurface extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final List<Color>? colors;

  const IridescentSurface({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final iridColors = colors ?? [
      AppTheme.iridescent,
      AppTheme.roseGold,
      AppTheme.champagneGold,
      AppTheme.platinumSilver,
      AppTheme.iridescent,
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: iridColors,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius - 2),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: child,
      ),
    );
  }
}

/// Crystal Effect with Facets
class CrystalEffect extends StatelessWidget {
  final Widget child;
  final double size;
  final Color color;

  const CrystalEffect({
    super.key,
    required this.child,
    this.size = 100,
    this.color = const Color(0xFFE5E4E2),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Multiple layered shapes for facet effect
        ...List.generate(6, (index) {
          final angle = (index * 60) * 3.14159 / 180;
          return Transform.rotate(
            angle: angle,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.1),
                    color.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
                border: Border.all(
                  color: color.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
          );
        }),
        child,
      ],
    );
  }
}

/// Luxury Frosted Glass Effect
class LuxuryFrostedGlass extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color? tintColor;
  final BorderRadius? borderRadius;

  const LuxuryFrostedGlass({
    super.key,
    required this.child,
    this.blur = 20,
    this.opacity = 0.1,
    this.tintColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: (tintColor ?? Colors.white).withValues(alpha: opacity),
            borderRadius: borderRadius ?? BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Holographic Effect
class HolographicEffect extends StatelessWidget {
  final Widget child;
  final double borderRadius;

  const HolographicEffect({
    super.key,
    required this.child,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF00FF),
            Color(0xFF00FFFF),
            Color(0xFFFFFF00),
            Color(0xFFFF00FF),
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius - 3),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                Color(0x1AFF00FF),
                Color(0x1A00FFFF),
                Color(0x1AFFFF00),
                Colors.transparent,
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcOver,
          child: child,
        ),
      ),
    );
  }
}

/// Marble Pattern Background
class MarblePattern extends StatelessWidget {
  final Widget child;
  final Color primaryColor;
  final Color secondaryColor;

  const MarblePattern({
    super.key,
    required this.child,
    this.primaryColor = const Color(0xFFE5E4E2),
    this.secondaryColor = const Color(0xFFD4AF37),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: MarblePatternPainter(
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
          ),
        ),
        child,
      ],
    );
  }
}

/// Marble Pattern Painter
class MarblePatternPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  MarblePatternPainter({
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Create marble veins
    final path = Path();
    
    // First vein
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.3, size.height * 0.4,
      size.width * 0.6, size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.2,
      size.width, size.height * 0.35,
    );
    
    paint.color = secondaryColor.withValues(alpha: 0.1);
    paint.strokeWidth = 20;
    paint.style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
    
    // Second vein
    final path2 = Path();
    path2.moveTo(size.width * 0.2, 0);
    path2.quadraticBezierTo(
      size.width * 0.4, size.height * 0.3,
      size.width * 0.3, size.height * 0.6,
    );
    path2.quadraticBezierTo(
      size.width * 0.2, size.height * 0.8,
      size.width * 0.4, size.height,
    );
    
    paint.color = secondaryColor.withValues(alpha: 0.08);
    paint.strokeWidth = 30;
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}