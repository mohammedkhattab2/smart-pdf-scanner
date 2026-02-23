import 'package:equatable/equatable.dart';

/// States for the scanner flow (camera + cropping).
///
/// Keep the states generic for now; they will be extended when
/// the full feature logic is implemented.
abstract class ScannerState extends Equatable {
  const ScannerState();

  @override
  List<Object?> get props => [];
}

class ScannerInitial extends ScannerState {
  const ScannerInitial();
}

class ScannerLoading extends ScannerState {
  const ScannerLoading();
}

class ScannerCaptured extends ScannerState {
  final String imagePath;

  const ScannerCaptured(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class ScannerCropped extends ScannerState {
  final String imagePath;

  const ScannerCropped(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class ScannerError extends ScannerState {
  final String message;

  const ScannerError(this.message);

  @override
  List<Object?> get props => [message];
}