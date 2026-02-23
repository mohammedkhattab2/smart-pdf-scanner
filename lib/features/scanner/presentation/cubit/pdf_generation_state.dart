import 'package:equatable/equatable.dart';

import '../../domain/entities/scanned_document.dart';

/// States for the PDF generation + save flow.
abstract class PdfGenerationState extends Equatable {
  const PdfGenerationState();

  @override
  List<Object?> get props => [];
}

class PdfGenerationInitial extends PdfGenerationState {
  const PdfGenerationInitial();
}

class PdfGenerationLoading extends PdfGenerationState {
  const PdfGenerationLoading();
}

class PdfGenerationSuccess extends PdfGenerationState {
  final ScannedDocument document;

  const PdfGenerationSuccess(this.document);

  @override
  List<Object?> get props => [document];
}

class PdfGenerationError extends PdfGenerationState {
  final String message;

  const PdfGenerationError(this.message);

  @override
  List<Object?> get props => [message];
}