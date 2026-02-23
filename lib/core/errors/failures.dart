/// Base class for all domain-level failures.
///
/// Failures are used instead of throwing exceptions across layers so that
/// UseCases can return a typed error result (e.g. Either<Failure, T>).
abstract class Failure {
  /// Human-readable message that can be shown to the user (or mapped to one).
  final String message;

  /// Optional machine-readable code/tag for logging or analytics.
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => 'Failure(code: $code, message: $message)';
}

/// Failure related to camera access or usage.
class CameraFailure extends Failure {
  const CameraFailure(String message, {String? code})
      : super(message, code: code ?? 'camera_failure');
}

/// Failure when saving a file (e.g. PDF) fails.
class FileSaveFailure extends Failure {
  const FileSaveFailure(String message, {String? code})
      : super(message, code: code ?? 'file_save_failure');
}

/// Failure when reading or listing files fails.
class FileReadFailure extends Failure {
  const FileReadFailure(String message, {String? code})
      : super(message, code: code ?? 'file_read_failure');
}

/// Failure when opening a file with an external viewer fails.
class FileOpenFailure extends Failure {
  const FileOpenFailure(String message, {String? code})
      : super(message, code: code ?? 'file_open_failure');
}

/// Failure when sharing a file via other apps fails.
class ShareFailure extends Failure {
  const ShareFailure(String message, {String? code})
      : super(message, code: code ?? 'share_failure');
}

/// Generic unexpected failure for unknown or uncategorized errors.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(String message, {String? code})
      : super(message, code: code ?? 'unexpected_failure');
}