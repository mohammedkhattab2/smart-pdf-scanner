import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/capture_document_usecase.dart';
import '../../domain/usecases/crop_document_image_usecase.dart';
import 'scanner_state.dart';

/// Cubit responsible for the camera + image crop flow.
///
/// This Cubit does NOT contain any UI logic (no BuildContext, no Navigator).
/// It only exposes intents (capture, crop) and emits states that the UI
/// can react to.
class ScannerCubit extends Cubit<ScannerState> {
  final CaptureDocumentUseCase _captureDocumentUseCase;
  final CropDocumentImageUseCase _cropDocumentImageUseCase;

  ScannerCubit({
    required CaptureDocumentUseCase captureDocumentUseCase,
    required CropDocumentImageUseCase cropDocumentImageUseCase,
  })  : _captureDocumentUseCase = captureDocumentUseCase,
        _cropDocumentImageUseCase = cropDocumentImageUseCase,
        super(const ScannerInitial());

  /// Trigger the camera to capture a document image.
  Future<void> captureDocument() async {
    emit(const ScannerLoading());

    final result = await _captureDocumentUseCase(const NoParams());

    result.fold(
      (failure) => emit(ScannerError(failure.message)),
      (imagePath) => emit(ScannerCaptured(imagePath)),
    );
  }

  /// Open the crop UI for a previously captured image.
  ///
  /// The UI is responsible for navigating to the crop screen; this Cubit
  /// just exposes the business intent and state.
  Future<void> cropDocument(String imagePath) async {
    emit(const ScannerLoading());

    final result = await _cropDocumentImageUseCase(
      CropDocumentImageParams(imagePath: imagePath),
    );

    result.fold(
      (failure) => emit(ScannerError(failure.message)),
      (croppedImagePath) => emit(ScannerCropped(croppedImagePath)),
    );
  }

  /// Reset back to initial state (e.g. when leaving the flow).
  void reset() {
    emit(const ScannerInitial());
  }
}