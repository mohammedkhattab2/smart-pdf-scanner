import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/scanner_repository.dart';

/// Use case: capture a document image using the device camera.
///
/// Returns the temporary image file path on success.
class CaptureDocumentUseCase implements UseCase<String, NoParams> {
  final ScannerRepository _repository;

  const CaptureDocumentUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return _repository.captureDocument();
  }
}