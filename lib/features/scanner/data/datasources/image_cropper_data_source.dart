import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

/// Low-level access to the image cropper plugin.
///
/// This data source receives a path to an existing image file and opens
/// the native crop UI, then returns the path of the newly cropped image.
abstract class ImageCropperDataSource {
  /// Open crop UI for the image at [imagePath] and return the cropped file path.
  ///
  /// Returns the new cropped image path on success.
  /// Throws on error; mapping to [Failure] is done in the repository layer.
  Future<String> cropImage(String imagePath);
}

class ImageCropperDataSourceImpl implements ImageCropperDataSource {
  final ImageCropper _cropper;

  ImageCropperDataSourceImpl({ImageCropper? cropper})
      : _cropper = cropper ?? ImageCropper();

  @override
  Future<String> cropImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('Image file does not exist at path: $imagePath');
      }

      final CroppedFile? cropped = await _cropper.cropImage(
        sourcePath: imagePath,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Document',
            toolbarColor: const Color(0xFF6200EE),
            toolbarWidgetColor: const Color(0xFFFFFFFF),
            hideBottomControls: false,
            lockAspectRatio: false,
            initAspectRatio: CropAspectRatioPreset.original,
            cropStyle: CropStyle.rectangle,
          ),
          IOSUiSettings(
            title: 'Crop Document',
            minimumAspectRatio: 0.5,
            aspectRatioLockEnabled: false,
            resetAspectRatioEnabled: true,
          ),
        ],
      );

      if (cropped == null) {
        // User cancelled the cropping
        return imagePath; // Return original image path if cancelled
      }

      final croppedFile = File(cropped.path);
      if (!await croppedFile.exists()) {
        throw Exception(
          'Cropped image file does not exist at path: ${cropped.path}',
        );
      }

      return cropped.path;
    } catch (e) {
      // Re-throw to be handled by the repository
      rethrow;
    }
  }
}