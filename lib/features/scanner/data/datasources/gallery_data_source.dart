import 'package:image_picker/image_picker.dart';

/// Low-level access to device gallery for image selection.
///
/// This data source handles image selection from the device gallery
/// and returns the path to the selected image.
abstract class GalleryDataSource {
  /// Pick an image from the device gallery.
  ///
  /// Returns the path to the selected image on success.
  /// Returns null if the user cancels the selection.
  /// Throws on error; mapping to [Failure] is done in the repository layer.
  Future<String?> pickImageFromGallery();
}

class GalleryDataSourceImpl implements GalleryDataSource {
  final ImagePicker _imagePicker;

  GalleryDataSourceImpl({ImagePicker? imagePicker})
      : _imagePicker = imagePicker ?? ImagePicker();

  @override
  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100, // Keep original quality
      );

      if (pickedFile == null) {
        // User cancelled the picker
        return null;
      }

      return pickedFile.path;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }
}