import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/widgets/luxury_components.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/scanned_document.dart';
import '../../domain/usecases/pick_image_from_gallery_usecase.dart';
import '../cubit/pdf_generation_cubit.dart';
import '../cubit/pdf_list_cubit.dart';
import '../cubit/pdf_list_state.dart';
import '../cubit/scanner_cubit.dart';
import 'camera_page.dart';
import 'image_crop_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../../l10n/app_localizations.dart';

/// Luxury Home Screen with Premium Design
class ScannerHomePage extends StatelessWidget {
  const ScannerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            // Luxury background pattern on top of white scaffold
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: DiamondPatternPainter(
                color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.accentColor
                  : AppTheme.primaryColor,
                opacity: Theme.of(context).brightness == Brightness.dark ? 0.02 : 0.03,
              ),
            ),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Premium App Bar
                  _buildLuxuryAppBar(context),
                  
                  // Content Area
                  Expanded(
                    child: BlocBuilder<PdfListCubit, PdfListState>(
                      builder: (context, state) {
                        if (state is PdfListLoading) {
                          return _buildLoadingState();
                        } else if (state is PdfListLoaded) {
                          if (state.documents.isEmpty) {
                            return _buildEmptyState(context);
                          }
                          return _buildPdfList(context, state.documents);
                        } else if (state is PdfListError) {
                          return _buildErrorState(context, state.message);
                        } else {
                          return _buildEmptyState(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        // Luxury FAB
        floatingActionButton: _buildLuxuryFAB(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildLuxuryAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LuxuryGradientText(
                    text: 'Smart PDF',
                    style: null,
                    gradient: null,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      LuxuryBadge(
                        text: AppLocalizations.of(context)?.premium.toUpperCase() ?? 'PREMIUM',
                        fontSize: 10,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)?.scanner ?? 'Scanner',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              LuxuryGlassCard(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                borderRadius: 20,
                hasGoldBorder: false,
                hasInnerShadow: false,
                child: IconButton(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: AppTheme.royalGold,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const LuxuryDivider(
            height: 20,
            margin: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: LuxuryLoadingIndicator(size: 64),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LuxuryGlassCard(
              borderRadius: 100,
              padding: const EdgeInsets.all(40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/playstore.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.document_scanner_outlined,
                      size: 80,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 48),
            LuxuryGradientText(
              text: AppLocalizations.of(context)?.noDocumentsYet ?? 'No Documents Yet',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)?.tapToScan ?? 'Tap the golden button below to\nscan your first document',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                height: 1.6,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: LuxuryGlassCard(
          backgroundColor: AppTheme.rubyRed.withValues(alpha: 0.1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.rubyRed.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.rubyRed,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)?.error ?? 'Error',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.rubyRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.rubyRed.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPdfList(BuildContext context, List<ScannedDocument> documents) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        return _buildLuxuryPdfCard(context, doc);
      },
    );
  }

  Widget _buildLuxuryPdfCard(BuildContext context, ScannedDocument doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 124, // increased more to fully avoid RenderFlex overflow on all devices
      child: Stack(
        children: [
          // Background gradient card
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.obsidianGradient
                : LinearGradient(
                    colors: [
                      Colors.white,
                      Color(0xFFF5F0FF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.accentColor.withValues(alpha: 0.3)
                  : AppTheme.primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.accentColor.withValues(alpha: 0.1)
                    : AppTheme.primaryColor.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                if (Theme.of(context).brightness == Brightness.light)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
          ),
          
          // Gold accent line
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                gradient: AppTheme.royalGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // PDF Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: AppTheme.imperialGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.deepAmethyst.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/playstore.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.picture_as_pdf,
                          size: 40,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // File info + bottom actions
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // File name (full, no truncation)
                      Text(
                        doc.fileName,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.accentColor
                            : AppTheme.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                          shadows: Theme.of(context).brightness == Brightness.dark
                            ? [
                                Shadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Date chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.accentColor.withValues(alpha: 0.1)
                            : AppTheme.primaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).brightness == Brightness.dark
                              ? AppTheme.accentColor.withValues(alpha: 0.3)
                              : AppTheme.primaryColor.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: Theme.of(context).brightness == Brightness.dark
                                ? AppTheme.accentColor
                                : AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDateLocalized(context, doc.createdAt),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).brightness == Brightness.dark
                                  ? AppTheme.accentColor
                                  : AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8), // مسافة إضافية بين التاريخ والأيقونات
                      // Action icons row towards the bottom (spaceBetween handles spacing)
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCircularActionButton(
                            context: context,
                            icon: Icons.open_in_new,
                            color: Theme.of(context).brightness == Brightness.dark
                              ? AppTheme.accentColor
                              : AppTheme.primaryColor,
                            size: 34,
                            onPressed: () {
                              context.read<PdfListCubit>().openDocument(doc);
                            },
                          ),
                          _buildCircularActionButton(
                            context: context,
                            icon: Icons.share,
                            color: AppTheme.emerald,
                            size: 34,
                            onPressed: () {
                              context.read<PdfListCubit>().shareDocument(doc);
                            },
                          ),
                          _buildCircularActionButton(
                            context: context,
                            icon: Icons.delete,
                            color: AppTheme.rubyRed,
                            size: 34,
                            onPressed: () {
                              _showDeleteDialog(context, doc);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularActionButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    double size = 44,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.1),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
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
              size: size * 0.5,
              color: color,
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildLuxuryFAB(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Gallery Import Button
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.accentColor.withValues(alpha: 0.5)
                  : AppTheme.primaryColor.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
                spreadRadius: 5,
              ),
            ],
          ),
          child: LuxuryButton(
            text: 'Import',
            icon: Icons.photo_library_outlined,
            width: 140,
            height: 56,
            borderRadius: 32,
            onPressed: () async {
              // Import from gallery
              _importFromGallery(context);
            },
          ),
        ),
        const SizedBox(width: 16),
        // Camera Scan Button
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.accentColor.withValues(alpha: 0.5)
                  : AppTheme.primaryColor.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
                spreadRadius: 5,
              ),
            ],
          ),
          child: LuxuryButton(
            text: 'Scan',
            icon: Icons.camera_alt_outlined,
            width: 140,
            height: 56,
            borderRadius: 32,
            onPressed: () {
              // Reset scanner state
              context.read<ScannerCubit>().reset();
              
              // Navigate to camera page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CameraPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Future<void> _importFromGallery(BuildContext context) async {
    final pickImageFromGalleryUseCase = sl<PickImageFromGalleryUseCase>();
    
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
      final result = await pickImageFromGalleryUseCase(const NoParams());
      
      // Hide loading
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      
      result.fold(
        (failure) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (imagePath) {
          if (imagePath != null && context.mounted) {
            // Navigate to image crop page
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: context.read<ScannerCubit>(),
                    ),
                    BlocProvider.value(
                      value: context.read<PdfGenerationCubit>(),
                    ),
                    BlocProvider.value(
                      value: context.read<PdfListCubit>(),
                    ),
                  ],
                  child: ImageCropPage(imagePath: imagePath),
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      // Hide loading if still showing
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to import image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteDialog(BuildContext context, ScannedDocument doc) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: LuxuryGlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 64,
                  color: AppTheme.rubyRed,
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)?.deleteDocument ?? 'Delete Document?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)?.deleteDocumentMessage ?? 'This action cannot be undone',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LuxuryButton(
                      text: AppLocalizations.of(context)?.cancel ?? 'Cancel',
                      isPrimary: false,
                      height: 48,
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                    LuxuryButton(
                      text: AppLocalizations.of(context)?.delete ?? 'Delete',
                      height: 48,
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.read<PdfListCubit>().deleteDocument(doc);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDateLocalized(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final l10n = AppLocalizations.of(context);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return l10n?.justNow ?? 'Just now';
        }
        return l10n?.minutesAgo(difference.inMinutes) ?? '${difference.inMinutes} minutes ago';
      }
      return l10n?.hoursAgo(difference.inHours) ?? '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return l10n?.yesterday ?? 'Yesterday';
    } else if (difference.inDays < 7) {
      return l10n?.daysAgo(difference.inDays) ?? '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}