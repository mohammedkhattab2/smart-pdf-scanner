import 'package:equatable/equatable.dart';

import '../../domain/entities/scanned_document.dart';

/// States for the PDF list (home screen) flow.
abstract class PdfListState extends Equatable {
  const PdfListState();

  @override
  List<Object?> get props => [];
}

class PdfListInitial extends PdfListState {
  const PdfListInitial();
}

class PdfListLoading extends PdfListState {
  const PdfListLoading();
}

class PdfListLoaded extends PdfListState {
  final List<ScannedDocument> documents;

  const PdfListLoaded(this.documents);

  @override
  List<Object?> get props => [documents];
}

class PdfListError extends PdfListState {
  final String message;

  const PdfListError(this.message);

  @override
  List<Object?> get props => [message];
}