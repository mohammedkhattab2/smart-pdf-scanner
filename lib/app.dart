import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/scanner/presentation/cubit/pdf_generation_cubit.dart';
import 'features/scanner/presentation/cubit/pdf_list_cubit.dart';
import 'features/scanner/presentation/cubit/scanner_cubit.dart';
import 'features/scanner/presentation/pages/scanner_home_page.dart';
import 'injection_container.dart';
import 'core/theme/app_theme.dart';

/// Root application widget for Smart PDF Scanner – Basic.
///
/// This widget wires the top-level Bloc providers and defines
/// the global MaterialApp configuration.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
      child: MaterialApp(
        title: 'Smart PDF Scanner',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const ScannerHomePage(),
      ),
    );
  }
}