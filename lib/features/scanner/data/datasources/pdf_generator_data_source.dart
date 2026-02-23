import 'dart:io';
import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

/// Low-level PDF generation from images.
///
/// This data source is responsible only for turning an image file into
/// PDF bytes. It does not know anything about where the PDF will be saved.
abstract class PdfGeneratorDataSource {
  /// Generate a single-page PDF from the image at [imagePath].
  ///
  /// Returns raw PDF bytes on success.
  Future<Uint8List> generatePdfFromImage(String imagePath);
}

class PdfGeneratorDataSourceImpl implements PdfGeneratorDataSource {
  @override
  Future<Uint8List> generatePdfFromImage(String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      throw Exception('Image file does not exist at path: $imagePath');
    }

    final imageBytes = await file.readAsBytes();

    final doc = pw.Document();

    final image = pw.MemoryImage(imageBytes);

    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          );
        },
      ),
    );

    return doc.save();
  }
}