import 'dart:io';

import 'package:share_plus/share_plus.dart';

/// Low-level data source for sharing PDF files via other apps.
abstract class PdfSharingDataSource {
  /// Share the PDF at the given [filePath] using the platform share sheet.
  ///
  /// Returns normally on success. Throws on error; mapping to a domain
  /// Failure is done in the repository layer.
  Future<void> sharePdf(String filePath);
}

class PdfSharingDataSourceImpl implements PdfSharingDataSource {
  @override
  Future<void> sharePdf(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('PDF file does not exist at path: $filePath');
    }

    await Share.shareXFiles(
      [XFile(filePath, mimeType: 'application/pdf')],
      subject: 'Shared PDF',
      text: 'Smart PDF Scanner – shared document',
    );
  }
}