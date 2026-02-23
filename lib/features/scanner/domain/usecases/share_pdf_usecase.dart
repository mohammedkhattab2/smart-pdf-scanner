import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/scanned_document.dart';
import '../repositories/scanner_repository.dart';

/// Params required to share a PDF document.
class SharePdfParams {
  final ScannedDocument document;

  const SharePdfParams({required this.document});
}

/// Use case: share a scanned PDF document via other apps.
class SharePdfUseCase implements UseCase<Unit, SharePdfParams> {
  final ScannerRepository _repository;

  const SharePdfUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(SharePdfParams params) {
    return _repository.sharePdf(params.document);
  }
}