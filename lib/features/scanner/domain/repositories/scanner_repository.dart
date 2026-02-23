import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/scanned_document.dart';

/// Abstraction for all scanner-related operations.
///
/// The implementation will live in the data layer and talk to:
/// - Camera & image cropping plugins
/// - PDF generation
/// - Local file storage
/// - File opening & sharing
abstract class ScannerRepository {
  /// Capture a document image using the device camera.
  ///
  /// Returns the temporary image file path on success.
  Future<Either<Failure, String>> captureDocument();

  /// Crop a previously captured image.
  ///
  /// [imagePath] is the path to the original captured image.
  /// Returns the cropped image file path on success.
  Future<Either<Failure, String>> cropDocumentImage(String imagePath);

  /// Generate a single-page PDF from an image.
  ///
  /// [imagePath] is the path to the (cropped) image.
  /// Returns the generated PDF bytes on success.
  Future<Either<Failure, Uint8List>> generatePdfFromImage(
    String imagePath,
  );

  /// Save a generated PDF to app-specific local storage.
  ///
  /// [pdfBytes] are the bytes produced by [generatePdfFromImage].
  /// [suggestedName] is a human-friendly base name (without extension).
  ///
  /// Returns the domain entity describing the stored document.
  Future<Either<Failure, ScannedDocument>> savePdf({
    required Uint8List pdfBytes,
    required String suggestedName,
  });

  /// Get all previously saved scanned documents.
  Future<Either<Failure, List<ScannedDocument>>> getSavedPdfs();

  /// Open a PDF document with the system PDF viewer.
  Future<Either<Failure, Unit>> openPdf(ScannedDocument document);

  /// Share a PDF document with other apps (WhatsApp, Gmail, Drive, etc.).
  Future<Either<Failure, Unit>> sharePdf(ScannedDocument document);
}