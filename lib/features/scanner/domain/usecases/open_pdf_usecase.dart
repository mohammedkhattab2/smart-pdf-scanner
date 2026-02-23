import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/scanned_document.dart';
import '../repositories/scanner_repository.dart';

/// Params required to open a PDF document.
class OpenPdfParams {
  final ScannedDocument document;

  const OpenPdfParams({required this.document});
}

/// Use case: open a scanned PDF document with the system viewer.
class OpenPdfUseCase implements UseCase<Unit, OpenPdfParams> {
  final ScannerRepository _repository;

  const OpenPdfUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(OpenPdfParams params) {
    return _repository.openPdf(params.document);
  }
}