import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/scanner_repository.dart';

/// Params required to crop a previously captured document image.
class CropDocumentImageParams {
  /// Path to the original captured image to be cropped.
  final String imagePath;

  const CropDocumentImageParams({
    required this.imagePath,
  });
}

/// Use case: crop a previously captured document image.
///
/// Delegates to [ScannerRepository.cropDocumentImage] and returns
/// the new cropped image path on success.
class CropDocumentImageUseCase
    implements UseCase<String, CropDocumentImageParams> {
  final ScannerRepository _repository;

  const CropDocumentImageUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(CropDocumentImageParams params) {
    return _repository.cropDocumentImage(params.imagePath);
  }
}