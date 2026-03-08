import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/luxury_components.dart';
import '../../../scanner/presentation/pages/scanner_home_page.dart';

class PermissionRequestPage extends StatefulWidget {
  const PermissionRequestPage({super.key});

  @override
  State<PermissionRequestPage> createState() => _PermissionRequestPageState();
}

class _PermissionRequestPageState extends State<PermissionRequestPage> {
  bool _isRequesting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.obsidianGradient
              : AppTheme.imperialGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.royalGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.royalGold.withValues(alpha: 0.5),
                        blurRadius: 40,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.security_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),

                // Title
                Text(
                  'أذونات التطبيق',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Description
                Text(
                  'يحتاج التطبيق إلى الأذونات التالية للعمل بشكل صحيح',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.6,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Permission Cards
                _buildPermissionCard(
                  icon: Icons.camera_alt,
                  title: 'الكاميرا',
                  description: 'لالتقاط صور المستندات',
                ),
                const SizedBox(height: 16),
                _buildPermissionCard(
                  icon: Icons.photo_library,
                  title: 'معرض الصور',
                  description: 'لاستيراد الصور من جهازك',
                ),
                const SizedBox(height: 16),
                _buildPermissionCard(
                  icon: Icons.folder,
                  title: 'الملفات',
                  description: 'لحفظ ملفات PDF',
                ),
                const SizedBox(height: 48),

                // Grant Button
                LuxuryButton(
                  text: _isRequesting ? 'جاري طلب الأذونات...' : 'منح الأذونات',
                  icon: Icons.check_circle_outline,
                  width: double.infinity,
                  height: 56,
                  onPressed: _isRequesting ? () {} : () => _requestPermissions(),
                ),
                const SizedBox(height: 16),

                // Skip button
                TextButton(
                  onPressed: _isRequesting ? null : _skipPermissions,
                  child: Text(
                    'تخطي الآن',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestPermissions() async {
    setState(() {
      _isRequesting = true;
    });

    try {
      // Request permissions - these will show native permission dialogs
      final Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.photos,
      ].request();

      // Check if permissions are granted
      bool cameraGranted = statuses[Permission.camera] == PermissionStatus.granted;
      bool photosGranted = statuses[Permission.photos] == PermissionStatus.granted || 
                           statuses[Permission.photos] == PermissionStatus.limited;

      if (!mounted) return;

      // Save that permissions have been requested
      await _savePermissionRequested();

      if (cameraGranted && photosGranted) {
        // All permissions granted, navigate to home
        _navigateToHome();
      } else {
        // Some permissions denied, show message but still allow proceeding
        _showPermissionDeniedDialog();
      }
    } catch (e) {
      // Error requesting permissions - still allow user to proceed
      if (mounted) {
        await _savePermissionRequested();
        _navigateToHome();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }

  void _skipPermissions() {
    _savePermissionRequested();
    _navigateToHome();
  }

  Future<void> _savePermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('permissions_requested', true);
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ScannerHomePage(),
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('بعض الأذونات مرفوضة'),
        content: const Text(
          'يمكنك استخدام التطبيق ولكن بعض الميزات قد لا تعمل بشكل صحيح. يمكنك تفعيل الأذونات لاحقًا من إعدادات النظام.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('فتح الإعدادات'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToHome();
            },
            child: const Text('متابعة'),
          ),
        ],
      ),
    );
  }
}