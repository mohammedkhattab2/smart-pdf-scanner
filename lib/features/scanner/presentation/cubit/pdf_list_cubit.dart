import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/scanned_document.dart';
import '../../domain/usecases/get_saved_pdfs_usecase.dart';
import '../../domain/usecases/open_pdf_usecase.dart';
import '../../domain/usecases/share_pdf_usecase.dart';
import '../../domain/usecases/delete_pdf_usecase.dart';
import 'pdf_list_state.dart';

/// Cubit responsible for loading, opening, and sharing saved PDF documents.
///
/// It is used by the home screen to:
/// - Load the list of PDFs from local storage
/// - Open a selected PDF with the system viewer
/// - Share a selected PDF via other apps
class PdfListCubit extends Cubit<PdfListState> {
  final GetSavedPdfsUseCase _getSavedPdfsUseCase;
  final OpenPdfUseCase _openPdfUseCase;
  final SharePdfUseCase _sharePdfUseCase;
  final DeletePdfUseCase _deletePdfUseCase;

  PdfListCubit({
    required GetSavedPdfsUseCase getSavedPdfsUseCase,
    required OpenPdfUseCase openPdfUseCase,
    required SharePdfUseCase sharePdfUseCase,
    required DeletePdfUseCase deletePdfUseCase,
  })  : _getSavedPdfsUseCase = getSavedPdfsUseCase,
        _openPdfUseCase = openPdfUseCase,
        _sharePdfUseCase = sharePdfUseCase,
        _deletePdfUseCase = deletePdfUseCase,
        super(const PdfListInitial());

  /// Load all saved PDFs from local storage.
  Future<void> loadPdfs() async {
    emit(const PdfListLoading());

    final result = await _getSavedPdfsUseCase(const NoParams());

    result.fold(
      (failure) => emit(PdfListError(failure.message)),
      (documents) => emit(PdfListLoaded(documents)),
    );
  }

  /// Open the given [document] with the system PDF viewer.
  ///
  /// UI remains on the same screen; any error is surfaced as a transient
  /// error state.
  Future<void> openDocument(ScannedDocument document) async {
    final current = state;
    emit(const PdfListLoading());

    final result = await _openPdfUseCase(OpenPdfParams(document: document));

    result.fold(
      (failure) => emit(PdfListError(failure.message)),
      (_) {
        // Restore previous list state if we had it, otherwise reload.
        if (current is PdfListLoaded) {
          emit(current);
        } else {
          loadPdfs();
        }
      },
    );
  }

  /// Share the given [document] through available share targets.
  Future<void> shareDocument(ScannedDocument document) async {
    final current = state;
    emit(const PdfListLoading());

    final result =
        await _sharePdfUseCase(SharePdfParams(document: document));

    result.fold(
      (failure) => emit(PdfListError(failure.message)),
      (_) {
        // Sharing does not change the list, so restore previous state if any.
        if (current is PdfListLoaded) {
          emit(current);
        } else {
          loadPdfs();
        }
      },
    );
  }
  
  /// Delete the given [document] from storage.
  Future<void> deleteDocument(ScannedDocument document) async {
    emit(const PdfListLoading());
    
    final result = await _deletePdfUseCase(DeletePdfParams(document: document));
    
    result.fold(
      (failure) => emit(PdfListError(failure.message)),
      (_) {
        // Reload the list after deletion
        loadPdfs();
      },
    );
  }
}