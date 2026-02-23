import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/scanned_document.dart';
import '../repositories/scanner_repository.dart';

/// Use case: load all saved scanned PDF documents from local storage.
class GetSavedPdfsUseCase
    implements UseCase<List<ScannedDocument>, NoParams> {
  final ScannerRepository _repository;

  const GetSavedPdfsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ScannedDocument>>> call(NoParams params) {
    return _repository.getSavedPdfs();
  }
}