import 'dart:io';

import 'package:camera/camera.dart';

/// Low-level access to the device camera for capturing document images.
///
/// This data source is intentionally simple for the Basic MVP:
/// - It uses the first available camera.
/// - It captures a single picture and returns its file path.
/// - Camera controller lifecycle (init/dispose) is managed inside the method
///   for simplicity.
abstract class CameraDataSource {
  /// Capture an image using the device camera and return the image file path.
  ///
  /// Throws a [CameraException] or [Exception] on errors. The repository layer
  /// is responsible for mapping those exceptions to domain [Failure] objects.
  Future<String> captureImage();
}

class CameraDataSourceImpl implements CameraDataSource {
  @override
  Future<String> captureImage() async {
    // Ensure cameras are initialized.
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw CameraException(
        'no_camera',
        'No available camera on this device.',
      );
    }

    final camera = cameras.first;

    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await controller.initialize();

      final XFile file = await controller.takePicture();

      // Ensure the path exists and is accessible.
      if (!await File(file.path).exists()) {
        throw CameraException(
          'file_missing',
          'Captured image file does not exist at path: ${file.path}',
        );
      }

      return file.path;
    } finally {
      await controller.dispose();
    }
  }
}