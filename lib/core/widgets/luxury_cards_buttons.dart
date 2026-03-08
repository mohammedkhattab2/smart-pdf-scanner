import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Premium Card with Multiple Style Variants
class PremiumCard extends StatelessWidget {
  final Widget child;
  final CardVariant variant;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final double borderRadius;

  const PremiumCard({
    super.key,
    required this.child,
    this.variant = CardVariant.glass,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    Widget card;
    
    switch (variant) {
      case CardVariant.glass:
        card = _buildGlassCard(context);
      case CardVariant.metallic:
        card = _buildMetallicCard(context);
      case CardVariant.velvet:
        card = _buildVelvetCard(context);
      case CardVariant.diamond:
        card = _buildDiamondCard(context);
      case CardVariant.iridescent:
        card = _buildIridescentCard(context);
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }

  Widget _buildGlassCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: isDark ? 0.1 : 0.2),
                  Colors.white.withValues(alpha: isDark ? 0.05 : 0.1),
                ],
              ),
              border: Border.all(
                color: AppTheme.royalGold.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.royalGold.withValues(alpha: 0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            padding: padding ?? const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildMetallicCard(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: AppTheme.metallicGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.metallicGold.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius - 2),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
            ],
          ),
        ),
        padding: padding ?? const EdgeInsets.all(24),
        child: child,
      ),
    );
  }

  Widget _buildVelvetCard(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: AppTheme.velvetGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.burgundy.withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius - 1),
          color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
        ),
        padding: padding ?? const EdgeInsets.all(24),
        child: child,
      ),
    );
  }

  Widget _buildDiamondCard(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: Stack(
        children: [
          // Diamond pattern background
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: AppTheme.diamondGradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: -5,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),
          // Content
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: AppTheme.platinumSilver.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            padding: padding ?? const EdgeInsets.all(24),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildIridescentCard(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: AppTheme.iridescentGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.iridescent.withValues(alpha: 0.4),
            blurRadius: 24,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius - 3),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        padding: padding ?? const EdgeInsets.all(24),
        child: child,
      ),
    );
  }
}

enum CardVariant {
  glass,
  metallic,
  velvet,
  diamond,
  iridescent,
}

/// Premium Button Collection
class PremiumButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final double? width;
  final double height;
  final bool isLoading;
  final bool isDisabled;

  const PremiumButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.gradient,
    this.icon,
    this.width,
    this.height = 56,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isDisabled || isLoading ? null : onPressed;
    
    switch (variant) {
      case ButtonVariant.gradient:
        return _buildGradientButton(context, effectiveOnPressed);
      case ButtonVariant.outline:
        return _buildOutlineButton(context, effectiveOnPressed);
      case ButtonVariant.glass:
        return _buildGlassButton(context, effectiveOnPressed);
      case ButtonVariant.metallic:
        return _buildMetallicButton(context, effectiveOnPressed);
      case ButtonVariant.jewel:
        return _buildJewelButton(context, effectiveOnPressed);
    }
  }

  Widget _buildGradientButton(BuildContext context, VoidCallback? onPressed) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: isDisabled 
          ? LinearGradient(colors: [Colors.grey[400]!, Colors.grey[600]!])
          : AppTheme.royalGradient,
        boxShadow: isDisabled ? null : [
          BoxShadow(
            color: AppTheme.royalGold.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(height / 2),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(height / 2),
          child: _buildButtonContent(
            context,
            textColor: AppTheme.obsidianBlack,
            iconColor: AppTheme.obsidianBlack,
          ),
        ),
      ),
    );
  }

  Widget _buildOutlineButton(BuildContext context, VoidCallback? onPressed) {
    final color = isDisabled ? Colors.grey : AppTheme.royalGold;
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(height / 2),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(height / 2),
          child: _buildButtonContent(
            context,
            textColor: color,
            iconColor: color,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton(BuildContext context, VoidCallback? onPressed) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height / 2),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(
                color: AppTheme.royalGold.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(height / 2),
                child: _buildButtonContent(
                  context,
                  textColor: AppTheme.royalGold,
                  iconColor: AppTheme.royalGold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetallicButton(BuildContext context, VoidCallback? onPressed) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: AppTheme.metallicGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.metallicGold.withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(height / 2),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(height / 2),
          child: _buildButtonContent(
            context,
            textColor: AppTheme.obsidianBlack,
            iconColor: AppTheme.obsidianBlack,
          ),
        ),
      ),
    );
  }

  Widget _buildJewelButton(BuildContext context, VoidCallback? onPressed) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: RadialGradient(
          colors: [
            AppTheme.rubyRed,
            HSLColor.fromColor(AppTheme.rubyRed)
                .withLightness(HSLColor.fromColor(AppTheme.rubyRed).lightness * 0.7)
                .toColor(),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.rubyRed.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.3),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.2),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(height / 2),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(height / 2),
            child: _buildButtonContent(
              context,
              textColor: Colors.white,
              iconColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(
    BuildContext context, {
    required Color textColor,
    required Color iconColor,
  }) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

enum ButtonVariant {
  gradient,
  outline,
  glass,
  metallic,
  jewel,
}

/// Luxury Icon Button
class LuxuryIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool hasGlow;
  final String? tooltip;

  const LuxuryIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 48,
    this.backgroundColor,
    this.iconColor,
    this.hasGlow = true,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: backgroundColor != null 
          ? null 
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.royalGold,
                AppTheme.champagneGold,
              ],
            ),
        color: backgroundColor,
        boxShadow: hasGlow ? [
          BoxShadow(
            color: (backgroundColor ?? AppTheme.royalGold).withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(
              icon,
              color: iconColor ?? AppTheme.obsidianBlack,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Luxury Toggle Button
class LuxuryToggleButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? activeText;
  final String? inactiveText;
  final IconData? activeIcon;
  final IconData? inactiveIcon;
  final double width;
  final double height;

  const LuxuryToggleButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeText,
    this.inactiveText,
    this.activeIcon,
    this.inactiveIcon,
    this.width = 200,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          gradient: value ? AppTheme.royalGradient : null,
          color: value ? null : Colors.grey[800],
          boxShadow: [
            if (value)
              BoxShadow(
                color: AppTheme.royalGold.withValues(alpha: 0.5),
                blurRadius: 20,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (value && activeIcon != null || !value && inactiveIcon != null) ...[
                Icon(
                  value ? activeIcon : inactiveIcon,
                  color: value ? AppTheme.obsidianBlack : Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
              ],
              Text(
                value ? (activeText ?? 'ON') : (inactiveText ?? 'OFF'),
                style: TextStyle(
                  color: value ? AppTheme.obsidianBlack : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}