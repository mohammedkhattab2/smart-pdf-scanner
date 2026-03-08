import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../../../core/theme/app_theme.dart';
import '../../../scanner/presentation/pages/scanner_home_page.dart';
import '../../../permissions/presentation/pages/permission_request_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _glowController;
  late AnimationController _textController;
  late AnimationController _particleController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _glowAnimation;
  late Animation<double> _textOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _logoRotation = Tween<double>(
      begin: -0.5,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));
    
    // Glow animation
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    ));
    
    _textSlide = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
    ));
    
    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleController);
    
    // Start animations sequence
    _startAnimations();
    
    // Navigate after delay
    Timer(const Duration(seconds: 4), () async {
      final prefs = await SharedPreferences.getInstance();
      final permissionsRequested = prefs.getBool('permissions_requested') ?? false;
      
      if (!mounted) return;
      
      Widget targetPage = permissionsRequested
          ? const ScannerHomePage()
          : const PermissionRequestPage();
      
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => targetPage,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }
  
  void _startAnimations() {
    _logoController.forward();
    Timer(const Duration(milliseconds: 500), () {
      _textController.forward();
    });
  }
  
  @override
  void dispose() {
    _logoController.dispose();
    _glowController.dispose();
    _textController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF050109),
      ),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF050109), // Cosmic Black Purple
                Color(0xFF1A102A), // Midnight Purple
                Color(0xFF050109),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Animated particles background
              AnimatedBuilder(
                animation: _particleAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: ParticlesPainter(
                      animation: _particleAnimation.value,
                    ),
                  );
                },
              ),
              
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with animations
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _logoController,
                        _glowController,
                      ]),
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScale.value,
                          child: Transform.rotate(
                            angle: _logoRotation.value,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  // Outer glow
                                  BoxShadow(
                                    color: AppTheme.accentColor.withValues(
                                      alpha: 0.3 * _glowAnimation.value,
                                    ),
                                    blurRadius: 60,
                                    spreadRadius: 20,
                                  ),
                                  // Inner glow
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withValues(
                                      alpha: 0.5 * _glowAnimation.value,
                                    ),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                  // Core shadow
                                  const BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Rotating gradient ring
                                  RotationTransition(
                                    turns: _particleController,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: SweepGradient(
                                          colors: [
                                            AppTheme.accentColor.withValues(alpha: 0.0),
                                            AppTheme.accentColor.withValues(alpha: 0.5),
                                            AppTheme.primaryColor.withValues(alpha: 0.5),
                                            AppTheme.accentColor.withValues(alpha: 0.0),
                                          ],
                                          stops: const [0.0, 0.25, 0.75, 1.0],
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  // Logo image
                                  Container(
                                    width: 180,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppTheme.accentColor.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(90),
                                      child: Image.asset(
                                        'assets/playstore.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 80),
                    
                    // Animated text
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textOpacity.value,
                          child: Transform.translate(
                            offset: Offset(0, _textSlide.value),
                            child: Column(
                              children: [
                                // App name with gradient
                                ShaderMask(
                                  shaderCallback: (bounds) {
                                    return const LinearGradient(
                                      colors: [
                                        AppTheme.primaryColor,
                                        AppTheme.accentColor,
                                        AppTheme.primaryColor,
                                      ],
                                      stops: [0.0, 0.5, 1.0],
                                    ).createShader(bounds);
                                  },
                                  child: const Text(
                                    'Smart PDF',
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                
                                // Subtitle with glow
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppTheme.accentColor.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'SCANNER',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                      color: AppTheme.accentColor,
                                      letterSpacing: 8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 100),
                    
                    // Loading indicator
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textOpacity.value,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.royalGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.accentColor.withValues(
                                    alpha: 0.5,
                                  ),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              strokeWidth: 3,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              // Premium badge
              Positioned(
                top: 60,
                right: 20,
                child: AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textOpacity.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppTheme.royalGold,
                              AppTheme.champagneGold,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.royalGold.withValues(alpha: 0.5),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Text(
                          'PREMIUM',
                          style: TextStyle(
                            color: AppTheme.obsidianBlack,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Magical particles painter
class ParticlesPainter extends CustomPainter {
  final double animation;
  
  ParticlesPainter({required this.animation});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    // Draw floating particles
    for (int i = 0; i < 15; i++) {
      final progress = (animation + i / 15) % 1.0;
      final y = size.height * (1 - progress);
      final x = size.width * (0.2 + 0.6 * ((i * 0.13) % 1));
      final opacity = 1.0 - progress;
      final radius = 2 + (i % 3);
      
      paint.color = AppTheme.accentColor.withValues(alpha: opacity * 0.6);
      canvas.drawCircle(
        Offset(x, y),
        radius.toDouble(),
        paint,
      );
      
      // Add glow effect
      paint.color = AppTheme.accentColor.withValues(alpha: opacity * 0.2);
      canvas.drawCircle(
        Offset(x, y),
        radius * 3.0,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}