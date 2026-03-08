import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/app_settings.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import 'terms_of_service_page.dart';
import 'contact_support_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return _buildLoadingState();
          } else if (state is SettingsLoaded || state is SettingsUpdated) {
            final settings = state is SettingsLoaded 
                ? state.settings 
                : (state as SettingsUpdated).settings;
            return _buildSettingsContent(context, settings);
          } else if (state is SettingsError) {
            return _buildErrorState(state.message);
          } else {
            return _buildLoadingState();
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)?.settings ?? 'Settings'),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, AppSettings settings) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // App Info Section
        _buildAppInfoSection(context),
        const SizedBox(height: 32),
        
        // General Settings
        _buildSectionTitle(context, AppLocalizations.of(context)?.general ?? 'General', Icons.settings),
        const SizedBox(height: 16),
        _buildLanguageSelector(context, settings),
        const SizedBox(height: 16),
        _buildThemeSelector(context, settings),
        const SizedBox(height: 32),
        
        // PDF Settings
        _buildSectionTitle(context, AppLocalizations.of(context)?.pdfSettings ?? 'PDF Settings', null),
        const SizedBox(height: 16),
        _buildQualitySelector(context, settings),
        const SizedBox(height: 16),
        _buildAutoEnhanceToggle(context, settings),
        const SizedBox(height: 32),
        
        // About Section
        _buildSectionTitle(context, AppLocalizations.of(context)?.about ?? 'About', Icons.info),
        const SizedBox(height: 16),
        _buildAboutItems(context),
      ],
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  'assets/playstore.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.document_scanner,
                      size: 40,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Smart PDF Scanner',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)?.version ?? "Version"} 1.0.0',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData? icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: icon != null
            ? Icon(
                icon,
                color: Colors.white,
                size: 20,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'assets/playstore.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.picture_as_pdf,
                      size: 20,
                      color: Colors.white,
                    );
                  },
                ),
              ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector(BuildContext context, AppSettings settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.language),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.language ?? 'Language',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    settings.language == 'en' ? 'English' : 'العربية',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              initialValue: settings.language,
              onSelected: (value) {
                context.read<SettingsCubit>().updateLanguage(value);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
                const PopupMenuItem(
                  value: 'ar',
                  child: Text('العربية'),
                ),
              ],
              icon: const Icon(Icons.arrow_drop_down),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, AppSettings settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.palette),
                const SizedBox(width: 16),
                Text(
                  AppLocalizations.of(context)?.theme ?? 'Theme',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildThemeOption(
                  context,
                  AppLocalizations.of(context)?.lightTheme ?? 'Light',
                  Icons.light_mode,
                  settings.theme == 'light',
                  () => context.read<SettingsCubit>().updateTheme('light'),
                ),
                const SizedBox(width: 12),
                _buildThemeOption(
                  context,
                  AppLocalizations.of(context)?.darkTheme ?? 'Dark',
                  Icons.dark_mode,
                  settings.theme == 'dark',
                  () => context.read<SettingsCubit>().updateTheme('dark'),
                ),
                const SizedBox(width: 12),
                _buildThemeOption(
                  context,
                  AppLocalizations.of(context)?.systemTheme ?? 'System',
                  Icons.settings_brightness,
                  settings.theme == 'system',
                  () => context.read<SettingsCubit>().updateTheme('system'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected 
                    ? Colors.white
                    : Theme.of(context).iconTheme.color,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected 
                      ? Colors.white
                      : Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQualitySelector(BuildContext context, AppSettings settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.high_quality),
                const SizedBox(width: 16),
                Text(
                  AppLocalizations.of(context)?.pdfQuality ?? 'PDF Quality',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildQualityOption(
                  context,
                  AppLocalizations.of(context)?.low ?? 'Low',
                  settings.pdfQuality == 'low',
                  () => context.read<SettingsCubit>().updatePdfQuality('low'),
                ),
                const SizedBox(width: 12),
                _buildQualityOption(
                  context,
                  AppLocalizations.of(context)?.medium ?? 'Medium',
                  settings.pdfQuality == 'medium',
                  () => context.read<SettingsCubit>().updatePdfQuality('medium'),
                ),
                const SizedBox(width: 12),
                _buildQualityOption(
                  context,
                  AppLocalizations.of(context)?.high ?? 'High',
                  settings.pdfQuality == 'high',
                  () => context.read<SettingsCubit>().updatePdfQuality('high'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityOption(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected 
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAutoEnhanceToggle(BuildContext context, AppSettings settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.autoEnhance ?? 'Auto Enhance Images',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)?.autoEnhanceSubtitle ?? 'Automatically improve image quality',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: settings.autoEnhanceImages,
              onChanged: (value) {
                context.read<SettingsCubit>().toggleAutoEnhance();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutItems(BuildContext context) {
    return Column(
      children: [
        _buildAboutItem(
          context,
          AppLocalizations.of(context)?.privacyPolicy ?? 'Privacy Policy',
          Icons.privacy_tip,
          () {},
        ),
        const SizedBox(height: 12),
        _buildAboutItem(
          context,
          AppLocalizations.of(context)?.termsOfService ?? 'Terms of Service',
          Icons.description,
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const TermsOfServicePage(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildAboutItem(
          context,
          AppLocalizations.of(context)?.rateApp ?? 'Rate App',
          Icons.star,
          () {},
        ),
        const SizedBox(height: 12),
        _buildAboutItem(
          context,
          AppLocalizations.of(context)?.contactSupport ?? 'Contact Support',
          Icons.support_agent,
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ContactSupportPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAboutItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}