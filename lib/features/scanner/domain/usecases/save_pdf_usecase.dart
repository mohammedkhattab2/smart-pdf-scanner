import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/scanned_document.dart';
import '../repositories/scanner_repository.dart';

/// Params required to save a generated PDF to local storage.
class SavePdfParams {
  /// Raw PDF bytes generated from the image.
  final Uint8List pdfBytes;

  /// Human-friendly base name for the file (without extension).
  final String suggestedName;

  const SavePdfParams({
    required this.pdfBytes,
    required this.suggestedName,
  });
}

/// Use case: save a generated PDF into app-specific storage.
///
/// Delegates to [ScannerRepository.savePdf] and returns the created
/// [ScannedDocument] entity on success.
class SavePdfUseCase implements UseCase<ScannedDocument, SavePdfParams> {
  final ScannerRepository _repository;

  const SavePdfUseCase(this._repository);

  @override
  Future<Either<Failure, ScannedDocument>> call(SavePdfParams params) {
    return _repository.savePdf(
      pdfBytes: params.pdfBytes,
      suggestedName: params.suggestedName,
    );
  }
}