import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;

import '../../../../injection_container.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/scanned_document.dart';
import '../../domain/usecases/generate_pdf_from_image_usecase.dart';
import '../../domain/usecases/save_pdf_usecase.dart';
import 'pdf_generation_state.dart';

/// Cubit responsible for generating a PDF from an image and saving it locally.
///
/// Typical flow:
/// - UI passes the cropped image path and an optional suggested name.
/// - Cubit calls:
///   1) [GeneratePdfFromImageUseCase] to build PDF bytes.
///   2) [SavePdfUseCase] to persist the PDF and get back a [ScannedDocument].
class PdfGenerationCubit extends Cubit<PdfGenerationState> {
  final GeneratePdfFromImageUseCase _generatePdfFromImageUseCase;
  final SavePdfUseCase _savePdfUseCase;

  PdfGenerationCubit({
    required GeneratePdfFromImageUseCase generatePdfFromImageUseCase,
    required SavePdfUseCase savePdfUseCase,
  })  : _generatePdfFromImageUseCase = generatePdfFromImageUseCase,
        _savePdfUseCase = savePdfUseCase,
        super(const PdfGenerationInitial());

  /// Generate and save a PDF from the given [imagePath].
  ///
  /// [suggestedName] is used as base file name (without extension).
  Future<void> generateAndSave({
    required String imagePath,
    required String suggestedName,
  }) async {
    emit(const PdfGenerationLoading());

    // Check if auto-enhance is enabled
    String finalImagePath = imagePath;
    final settingsCubit = sl<SettingsCubit>();
    if (settingsCubit.currentSettings?.autoEnhanceImages ?? false) {
      // Apply auto-enhancement
      final enhancedPath = await _enhanceImageForPdf(imagePath);
      if (enhancedPath != null) {
        finalImagePath = enhancedPath;
      }
    }

    // Step 1: generate PDF bytes from image.
    final pdfResult = await _generatePdfFromImageUseCase(
      GeneratePdfFromImageParams(imagePath: finalImagePath),
    );

    await pdfResult.fold(
      (failure) async {
        emit(PdfGenerationError(failure.message));
      },
      (Uint8List pdfBytes) async {
        // Step 2: save PDF to local storage.
        final saveResult = await _savePdfUseCase(
          SavePdfParams(pdfBytes: pdfBytes, suggestedName: suggestedName),
        );

        saveResult.fold(
          (failure) => emit(PdfGenerationError(failure.message)),
          (ScannedDocument document) => emit(
            PdfGenerationSuccess(document),
          ),
        );
      },
    );
  }
  
  /// Enhance image for PDF if auto-enhance is enabled
  Future<String?> _enhanceImageForPdf(String imagePath) async {
    try {
      // Read the image
      final imageFile = File(imagePath);
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      
      if (image != null) {
        // Apply auto-enhancement
        // 1. Adjust brightness/contrast for better document clarity
        img.adjustColor(image, brightness: 1.1, contrast: 1.2);
        
        // 2. Normalize the image (stretch histogram)
        img.normalize(image, min: 0, max: 255);
        
        // Save to temporary file
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/enhanced_pdf_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await tempFile.writeAsBytes(img.encodeJpg(image, quality: 95));
        
        return tempFile.path;
      }
    } catch (e) {
      // If enhancement fails, use original image
      // Auto-enhancement failed - continue with original image
    }
    return null;
  }

  /// Reset back to initial state (e.g. after finishing a flow).
  void reset() {
    emit(const PdfGenerationInitial());
  }
}