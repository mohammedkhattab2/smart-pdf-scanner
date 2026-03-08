import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/scanned_document.dart';
import '../repositories/scanner_repository.dart';

/// Params for deleting a PDF document.
class DeletePdfParams extends Equatable {
  final ScannedDocument document;

  const DeletePdfParams({required this.document});

  @override
  List<Object?> get props => [document];
}

/// Use case to delete a saved PDF from storage.
class DeletePdfUseCase implements UseCase<Unit, DeletePdfParams> {
  final ScannerRepository repository;

  DeletePdfUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeletePdfParams params) async {
    return await repository.deletePdf(params.document);
  }
}