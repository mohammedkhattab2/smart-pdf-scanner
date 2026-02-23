import 'package:equatable/equatable.dart';

/// Domain entity representing a scanned PDF document.
///
/// This is pure domain model (no Flutter or plugin imports) so
/// it can be reused and tested independently of the UI and data layers.
class ScannedDocument extends Equatable {
  /// Unique identifier for the document (e.g. UUID or file name).
  final String id;

  /// Human-readable file name shown to the user.
  final String fileName;

  /// Absolute path to the PDF file on the device.
  final String filePath;

  /// Timestamp when the document was created/saved.
  final DateTime createdAt;

  const ScannedDocument({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, fileName, filePath, createdAt];
}