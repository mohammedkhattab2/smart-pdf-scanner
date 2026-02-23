import 'dart:io';

import '../../domain/entities/scanned_document.dart';

/// Data model that maps between filesystem data and the domain [ScannedDocument].
///
/// For this MVP we only persist PDFs as files on disk, so the "persistence"
/// format is effectively the filesystem itself. This model helps converting
/// between [File] metadata and the domain entity.
class ScannedDocumentModel {
  final String id;
  final String fileName;
  final String filePath;
  final DateTime createdAt;

  const ScannedDocumentModel({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.createdAt,
  });

  /// Build a [ScannedDocumentModel] from a [FileSystemEntity] representing a PDF.
  ///
  /// [id] can simply be the file name for this MVP.
  factory ScannedDocumentModel.fromFile(FileSystemEntity entity) {
    final file = File(entity.path);
    final stat = file.statSync();

    final fileName = entity.uri.pathSegments.isNotEmpty
        ? entity.uri.pathSegments.last
        : entity.path.split(Platform.pathSeparator).last;

    return ScannedDocumentModel(
      id: fileName,
      fileName: fileName,
      filePath: entity.path,
      createdAt: stat.changed, // creation/changed time; good enough for MVP
    );
  }

  /// Convert this model to a pure domain entity.
  ScannedDocument toEntity() {
    return ScannedDocument(
      id: id,
      fileName: fileName,
      filePath: filePath,
      createdAt: createdAt,
    );
  }

  /// Create a model from a domain entity (useful when saving).
  factory ScannedDocumentModel.fromEntity(ScannedDocument entity) {
    return ScannedDocumentModel(
      id: entity.id,
      fileName: entity.fileName,
      filePath: entity.filePath,
      createdAt: entity.createdAt,
    );
  }
}