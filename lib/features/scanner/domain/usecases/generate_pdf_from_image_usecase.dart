import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/scanner_repository.dart';

/// Params required to generate a PDF from an image.
class GeneratePdfFromImageParams {
  /// Path to the (cropped) image.
  final String imagePath;

  const GeneratePdfFromImageParams({required this.imagePath});
}

/// Use case: generate a single-page PDF from an image.
///
/// Delegates to [ScannerRepository.generatePdfFromImage] and returns
/// the generated PDF bytes on success.
class GeneratePdfFromImageUseCase
    implements UseCase<Uint8List, GeneratePdfFromImageParams> {
  final ScannerRepository _repository;

  const GeneratePdfFromImageUseCase(this._repository);

  @override
  Future<Either<Failure, Uint8List>> call(
    GeneratePdfFromImageParams params,
  ) {
    return _repository.generatePdfFromImage(params.imagePath);
  }
}