import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/scanner_repository.dart';

/// Use case: pick an image from the device gallery.
///
/// Returns the path to the selected image on success.
/// Returns null wrapped in Right if the user cancels.
class PickImageFromGalleryUseCase
    implements UseCase<String?, NoParams> {
  final ScannerRepository _repository;

  const PickImageFromGalleryUseCase(this._repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) {
    return _repository.pickImageFromGallery();
  }
}