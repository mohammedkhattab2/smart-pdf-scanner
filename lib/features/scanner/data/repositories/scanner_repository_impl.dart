import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/scanned_document.dart';
import '../../domain/repositories/scanner_repository.dart';
import '../datasources/camera_data_source.dart';
import '../datasources/image_cropper_data_source.dart';
import '../datasources/local_pdf_storage_data_source.dart';
import '../datasources/pdf_generator_data_source.dart';
import '../datasources/pdf_opener_data_source.dart';
import '../datasources/pdf_sharing_data_source.dart';

/// Concrete implementation of [ScannerRepository].
///
/// Bridges between the domain layer and:
/// - Camera
/// - Image cropper
/// - PDF generator
/// - Local storage
/// - File opener
/// - File sharing
class ScannerRepositoryImpl implements ScannerRepository {
  final CameraDataSource _cameraDataSource;
  final ImageCropperDataSource _imageCropperDataSource;
  final PdfGeneratorDataSource _pdfGeneratorDataSource;
  final LocalPdfStorageDataSource _localPdfStorageDataSource;
  final PdfOpenerDataSource _pdfOpenerDataSource;
  final PdfSharingDataSource _pdfSharingDataSource;

  const ScannerRepositoryImpl({
    required CameraDataSource cameraDataSource,
    required ImageCropperDataSource imageCropperDataSource,
    required PdfGeneratorDataSource pdfGeneratorDataSource,
    required LocalPdfStorageDataSource localPdfStorageDataSource,
    required PdfOpenerDataSource pdfOpenerDataSource,
    required PdfSharingDataSource pdfSharingDataSource,
  })  : _cameraDataSource = cameraDataSource,
        _imageCropperDataSource = imageCropperDataSource,
        _pdfGeneratorDataSource = pdfGeneratorDataSource,
        _localPdfStorageDataSource = localPdfStorageDataSource,
        _pdfOpenerDataSource = pdfOpenerDataSource,
        _pdfSharingDataSource = pdfSharingDataSource;

  @override
  Future<Either<Failure, String>> captureDocument() async {
    try {
      final path = await _cameraDataSource.captureImage();
      return Right(path);
    } on Exception catch (e) {
      return Left(
        CameraFailure(
          'Failed to capture image. Please check camera permissions.',
          code: 'capture_error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> cropDocumentImage(String imagePath) async {
    try {
      final croppedPath = await _imageCropperDataSource.cropImage(imagePath);
      return Right(croppedPath);
    } on Exception catch (_) {
      return const Left(
        CameraFailure(
          'Failed to crop image. Please try again.',
          code: 'crop_error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Uint8List>> generatePdfFromImage(
    String imagePath,
  ) async {
    try {
      final pdfBytes = await _pdfGeneratorDataSource.generatePdfFromImage(
        imagePath,
      );
      return Right(pdfBytes);
    } on Exception catch (_) {
      return const Left(
        FileSaveFailure(
          'Failed to generate PDF from image.',
          code: 'pdf_generation_error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ScannedDocument>> savePdf({
    required Uint8List pdfBytes,
    required String suggestedName,
  }) async {
    try {
      final model = await _localPdfStorageDataSource.savePdf(
        pdfBytes: pdfBytes,
        fileName: suggestedName,
      );
      return Right(model.toEntity());
    } on Exception catch (_) {
      return const Left(
        FileSaveFailure(
          'Failed to save PDF file to local storage.',
          code: 'pdf_save_error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ScannedDocument>>> getSavedPdfs() async {
    try {
      final models = await _localPdfStorageDataSource.getSavedPdfs();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on Exception catch (_) {
      return const Left(
        FileReadFailure(
          'Failed to load saved PDFs.',
          code: 'pdf_list_error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> openPdf(ScannedDocument document) async {
    try {
      await _pdfOpenerDataSource.openPdf(document.filePath);
      return const Right(unit);
    } on Exception catch (_) {
      return const Left(
        FileOpenFailure(
          'Failed to open PDF. Please make sure a PDF viewer is installed.',
          code: 'pdf_open_error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> sharePdf(ScannedDocument document) async {
    try {
      await _pdfSharingDataSource.sharePdf(document.filePath);
      return const Right(unit);
    } on Exception catch (_) {
      return const Left(
        ShareFailure(
          'Failed to share PDF. Please try again.',
          code: 'pdf_share_error',
        ),
      );
    }
  }
}