import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import '../models/scanned_document_model.dart';

/// Low-level access to local storage for saving and listing PDF files.
///
/// This data source:
/// - Resolves an app-specific directory for storing PDFs.
/// - Writes PDF bytes to a file.
/// - Lists stored PDF files and maps them to [ScannedDocumentModel].
abstract class LocalPdfStorageDataSource {
  /// Save [pdfBytes] to disk with the given [fileName] (without extension).
  ///
  /// Returns the created [ScannedDocumentModel] on success.
  Future<ScannedDocumentModel> savePdf({
    required Uint8List pdfBytes,
    required String fileName,
  });

  /// Get all stored PDFs as [ScannedDocumentModel]s.
  Future<List<ScannedDocumentModel>> getSavedPdfs();
  
  /// Delete a PDF file from storage.
  Future<void> deletePdf(String filePath);
}

class LocalPdfStorageDataSourceImpl implements LocalPdfStorageDataSource {
  static const String _pdfFolderName = 'scanned_pdfs';

  /// Resolve or create the directory where PDFs are stored.
  Future<Directory> _getPdfDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${docsDir.path}${Platform.pathSeparator}$_pdfFolderName');

    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }

    return pdfDir;
  }

  @override
  Future<ScannedDocumentModel> savePdf({
    required Uint8List pdfBytes,
    required String fileName,
  }) async {
    final pdfDir = await _getPdfDirectory();

    final sanitizedName = fileName.trim().isEmpty ? 'document' : fileName.trim();
    final fullPath = '${pdfDir.path}${Platform.pathSeparator}$sanitizedName.pdf';

    final file = File(fullPath);
    await file.writeAsBytes(pdfBytes, flush: true);

    // Build model from the newly created file.
    return ScannedDocumentModel.fromFile(file);
  }

  @override
  Future<List<ScannedDocumentModel>> getSavedPdfs() async {
    final pdfDir = await _getPdfDirectory();

    if (!await pdfDir.exists()) {
      return [];
    }

    final entities = pdfDir.listSync().whereType<File>().where(
          (file) => file.path.toLowerCase().endsWith('.pdf'),
        );

    final models = entities
        .map<ScannedDocumentModel>(
          (file) => ScannedDocumentModel.fromFile(file),
        )
        .toList();

    // Sort by creation date descending (newest first).
    models.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return models;
  }
  
  @override
  Future<void> deletePdf(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}