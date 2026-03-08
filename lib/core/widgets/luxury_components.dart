import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Luxury Glass Card with sophisticated styling
class LuxuryGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final LinearGradient? gradient;
  final Color? backgroundColor;
  final double borderRadius;
  final bool hasGoldBorder;
  final bool hasInnerShadow;

  const LuxuryGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.gradient,
    this.backgroundColor,
    this.borderRadius = 24.0,
    this.hasGoldBorder = false,
    this.hasInnerShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Stack(
        children: [
          // Outer glow effect
          if (hasGoldBorder)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.royalGold.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: AppTheme.champagneGold.withValues(alpha: 0.2),
                    blurRadius: 50,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          
          // Main card with glass effect
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: gradient ?? (isDark 
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.05),
                          Colors.white.withValues(alpha: 0.02),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black.withValues(alpha: 0.05),
                          Colors.black.withValues(alpha: 0.02),
                        ],
                      )
                  ),
                  border: Border.all(
                    width: hasGoldBorder ? 2 : 1,
                    color: hasGoldBorder 
                      ? AppTheme.royalGold.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: isDark ? 0.1 : 0.2),
                  ),
                  boxShadow: hasInnerShadow ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ] : null,
                ),
                child: Container(
                  padding: padding ?? const EdgeInsets.all(20),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Luxury Gradient Button
class LuxuryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isPrimary;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsets? padding;

  const LuxuryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.width,
    this.height = 56,
    this.borderRadius = 30,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: isPrimary
          ? (isDark ? AppTheme.royalGradient : LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ))
          : (isDark ? AppTheme.obsidianGradient : LinearGradient(
              colors: [
                Colors.grey.shade200,
                Colors.grey.shade300,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
        boxShadow: [
          BoxShadow(
            color: isPrimary
              ? (isDark ? AppTheme.accentColor : AppTheme.primaryColor).withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: isPrimary
                      ? Colors.white
                      : (isDark ? AppTheme.champagneGold : AppTheme.obsidianBlack),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isPrimary
                        ? Colors.white
                        : (isDark ? AppTheme.champagneGold : AppTheme.obsidianBlack),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Diamond Pattern Background
class DiamondPatternPainter extends CustomPainter {
  final Color color;
  final double opacity;

  DiamondPatternPainter({
    required this.color,
    this.opacity = 0.05,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    const diamondSize = 30.0;
    final path = Path();

    for (double x = -diamondSize; x < size.width + diamondSize; x += diamondSize * 2) {
      for (double y = -diamondSize; y < size.height + diamondSize; y += diamondSize * 2) {
        // Offset every other row for better pattern
        final offset = ((y / (diamondSize * 2)).floor() % 2 == 0) ? 0.0 : diamondSize;
        path.moveTo(x + offset, y - diamondSize);
        path.lineTo(x + offset + diamondSize, y);
        path.lineTo(x + offset, y + diamondSize);
        path.lineTo(x + offset - diamondSize, y);
        path.close();
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Luxury Icon Container
class LuxuryIconContainer extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? iconColor;
  final LinearGradient? backgroundGradient;
  final bool hasGlow;
  final double borderRadius;

  const LuxuryIconContainer({
    super.key,
    required this.icon,
    this.size = 56,
    this.iconColor,
    this.backgroundGradient,
    this.hasGlow = true,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: backgroundGradient ?? AppTheme.royalGradient,
        boxShadow: hasGlow ? [
          BoxShadow(
            color: (isDark ? AppTheme.accentColor : AppTheme.primaryColor).withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: (isDark ? AppTheme.accentColor : AppTheme.primaryColor).withValues(alpha: 0.3),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ] : null,
      ),
      child: Icon(
        icon,
        color: iconColor ?? Colors.white,
        size: size * 0.5,
      ),
    );
  }
}

/// Luxury Divider with Ornamental Design
class LuxuryDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final Color? color;
  final EdgeInsets? margin;
  final bool hasOrnament;

  const LuxuryDivider({
    super.key,
    this.height = 40,
    this.thickness = 1,
    this.color,
    this.margin,
    this.hasOrnament = true,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? AppTheme.royalGold.withValues(alpha: 0.3);
    
    return Container(
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: thickness,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    dividerColor,
                  ],
                ),
              ),
            ),
          ),
          if (hasOrnament)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    transform: Matrix4.rotationZ(0.785398), // 45 degrees
                    decoration: BoxDecoration(
                      color: dividerColor,
                    ),
                  ),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Container(
              height: thickness,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    dividerColor,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Luxury Text with Gradient Effect
class LuxuryGradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final LinearGradient? gradient;
  final TextAlign? textAlign;

  const LuxuryGradientText({
    super.key,
    required this.text,
    this.style,
    this.gradient,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultGradient = isDark ? AppTheme.royalGradient : LinearGradient(
      colors: [AppTheme.primaryColor, AppTheme.accentColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return (gradient ?? defaultGradient).createShader(bounds);
      },
      child: Text(
        text,
        style: (style ?? Theme.of(context).textTheme.displayLarge)?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        textAlign: textAlign,
      ),
    );
  }
}

/// Luxury Badge
class LuxuryBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsets? padding;

  const LuxuryBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            backgroundColor ?? AppTheme.accentColor,
            HSLColor.fromColor(backgroundColor ?? AppTheme.accentColor)
                .withLightness(HSLColor.fromColor(backgroundColor ?? AppTheme.accentColor).lightness * 0.8)
                .toColor(),
          ],
        ),
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? AppTheme.accentColor).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.black,
          fontSize: fontSize ?? 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

/// Luxury Loading Indicator
class LuxuryLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const LuxuryLoadingIndicator({
    super.key,
    this.size = 48,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isDark ? AppTheme.royalGradient : LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppTheme.accentColor : AppTheme.primaryColor).withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Colors.white,
        ),
        strokeWidth: 3,
      ),
    );
  }
}