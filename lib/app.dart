import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/scanner/presentation/cubit/pdf_generation_cubit.dart';
import 'features/scanner/presentation/cubit/pdf_list_cubit.dart';
import 'features/scanner/presentation/cubit/scanner_cubit.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
import 'features/settings/presentation/cubit/app_theme_cubit.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/settings_state.dart';
import 'injection_container.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

/// Root application widget for Smart PDF Scanner – Basic.
///
/// This widget wires the top-level Bloc providers and defines
/// the global MaterialApp configuration.
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Settings management (must be created first)
        BlocProvider<SettingsCubit>(
          create: (_) => sl<SettingsCubit>()..loadSettings(),
        ),
        
        // Theme management (depends on settings)
        BlocProvider<AppThemeCubit>(
          create: (context) => _createAppThemeCubit(context),
        ),

        // Scanner flow: camera + cropping.
        BlocProvider<ScannerCubit>(
          create: (_) => sl<ScannerCubit>(),
        ),

        // PDF generation and saving.
        BlocProvider<PdfGenerationCubit>(
          create: (_) => sl<PdfGenerationCubit>(),
        ),

        // List, open, and share PDFs.
        BlocProvider<PdfListCubit>(
          create: (_) => sl<PdfListCubit>()..loadPdfs(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        // Only rebuild when language changes
        buildWhen: (previous, current) {
          if (previous is SettingsLoaded && current is SettingsUpdated) {
            return previous.settings.language != current.settings.language;
          }
          if (previous is SettingsUpdated && current is SettingsUpdated) {
            return previous.settings.language != current.settings.language;
          }
          return true;
        },
        builder: (context, settingsState) {
          final locale = settingsState is SettingsLoaded
              ? Locale(settingsState.settings.language)
              : settingsState is SettingsUpdated
                  ? Locale(settingsState.settings.language)
                  : const Locale('en');
                  
          return BlocBuilder<AppThemeCubit, AppThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                title: 'Smart PDF Scanner',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                locale: locale,
                navigatorKey: navigatorKey, // Preserve navigation state
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'),
                  Locale('ar'),
                ],
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
  
  /// Creates and initializes the AppThemeCubit with proper settings synchronization.
  static AppThemeCubit _createAppThemeCubit(BuildContext context) {
    final cubit = sl<AppThemeCubit>();
    final settingsCubit = context.read<SettingsCubit>();
    
    // Synchronize theme with settings changes
    settingsCubit.stream.listen((state) {
      if (state is SettingsLoaded || state is SettingsUpdated) {
        final settings = state is SettingsLoaded
            ? state.settings
            : (state as SettingsUpdated).settings;
        cubit.setThemeFromString(settings.theme);
      }
    });
    
    // Set initial theme from current settings
    if (settingsCubit.currentSettings != null) {
      cubit.setThemeFromString(settingsCubit.currentSettings!.theme);
    }
    
    return cubit;
  }
}