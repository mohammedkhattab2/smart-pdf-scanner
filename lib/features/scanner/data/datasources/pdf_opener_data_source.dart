import 'dart:io';

import 'package:open_file/open_file.dart';

/// Low-level data source for opening PDF files with the system viewer.
abstract class PdfOpenerDataSource {
  /// Open the PDF at the given [filePath] with the platform's default viewer.
  ///
  /// Returns normally on success. Throws on error; mapping to a domain
  /// [Failure] is the responsibility of the repository layer.
  Future<void> openPdf(String filePath);
}

class PdfOpenerDataSourceImpl implements PdfOpenerDataSource {
  @override
  Future<void> openPdf(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('PDF file does not exist at path: $filePath');
    }

    final result = await OpenFile.open(filePath);

    if (result.type != ResultType.done) {
      throw Exception(
        'Failed to open PDF file at $filePath. '
        'OpenFile result: ${result.type}, message: ${result.message}',
      );
    }
  }
}