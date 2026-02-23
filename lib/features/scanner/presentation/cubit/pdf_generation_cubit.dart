import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
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

    // Step 1: generate PDF bytes from image.
    final pdfResult = await _generatePdfFromImageUseCase(
      GeneratePdfFromImageParams(imagePath: imagePath),
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

  /// Reset back to initial state (e.g. after finishing a flow).
  void reset() {
    emit(const PdfGenerationInitial());
  }
}