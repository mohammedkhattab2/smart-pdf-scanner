class ErrorMessages {
  // General errors
  static const String unknownError = 'An unknown error occurred';
  static const String noInternetConnection = 'No internet connection';
  static const String serverError = 'Server error occurred';
  static const String timeoutError = 'Request timed out';
  
  // Camera errors
  static const String cameraPermissionDenied = 'Camera permission denied';
  static const String cameraNotAvailable = 'Camera not available';
  static const String failedToTakePhoto = 'Failed to take photo';
  static const String cameraInitializationFailed = 'Failed to initialize camera';
  
  // Storage errors
  static const String storagePermissionDenied = 'Storage permission denied';
  static const String failedToSaveFile = 'Failed to save file';
  static const String failedToLoadFile = 'Failed to load file';
  static const String failedToDeleteFile = 'Failed to delete file';
  static const String insufficientStorage = 'Insufficient storage space';
  
  // PDF errors
  static const String failedToGeneratePdf = 'Failed to generate PDF';
  static const String failedToOpenPdf = 'Failed to open PDF';
  static const String failedToSharePdf = 'Failed to share PDF';
  static const String pdfNotFound = 'PDF file not found';
  static const String invalidPdfFormat = 'Invalid PDF format';
  
  // Image processing errors
  static const String failedToProcessImage = 'Failed to process image';
  static const String failedToCropImage = 'Failed to crop image';
  static const String invalidImageFormat = 'Invalid image format';
  static const String imageTooLarge = 'Image size too large';
  static const String imageNotFound = 'Image not found';
  
  // Gallery errors
  static const String galleryPermissionDenied = 'Gallery permission denied';
  static const String failedToPickImage = 'Failed to pick image from gallery';
  static const String noImageSelected = 'No image selected';
  
  // Settings errors
  static const String failedToLoadSettings = 'Failed to load settings';
  static const String failedToSaveSettings = 'Failed to save settings';
  static const String invalidSettingsFormat = 'Invalid settings format';
  static const String invalidFolderPath = 'Invalid folder path';
  
  // Validation errors
  static const String emptyFileName = 'File name cannot be empty';
  static const String invalidFileName = 'Invalid file name';
  static const String fileAlreadyExists = 'File already exists';
  static const String invalidInput = 'Invalid input';
  
  // Permission errors
  static const String permissionDenied = 'Permission denied';
  static const String permissionPermanentlyDenied = 'Permission permanently denied. Please enable it from settings';
  
  // App errors
  static const String failedToGetAppVersion = 'Failed to get app version';
  static const String failedToOpenAppSettings = 'Failed to open app settings';
  
  // Localization
  static String get(String key, {String? locale}) {
    // This would be replaced with actual localization logic
    return _messages[key] ?? key;
  }
  
  static final Map<String, String> _messages = {
    'unknown_error': unknownError,
    'no_internet': noInternetConnection,
    'server_error': serverError,
    'timeout_error': timeoutError,
    'camera_permission_denied': cameraPermissionDenied,
    'camera_not_available': cameraNotAvailable,
    'failed_to_take_photo': failedToTakePhoto,
    'camera_init_failed': cameraInitializationFailed,
    'storage_permission_denied': storagePermissionDenied,
    'failed_to_save_file': failedToSaveFile,
    'failed_to_load_file': failedToLoadFile,
    'failed_to_delete_file': failedToDeleteFile,
    'insufficient_storage': insufficientStorage,
    'failed_to_generate_pdf': failedToGeneratePdf,
    'failed_to_open_pdf': failedToOpenPdf,
    'failed_to_share_pdf': failedToSharePdf,
    'pdf_not_found': pdfNotFound,
    'invalid_pdf_format': invalidPdfFormat,
    'failed_to_process_image': failedToProcessImage,
    'failed_to_crop_image': failedToCropImage,
    'invalid_image_format': invalidImageFormat,
    'image_too_large': imageTooLarge,
    'image_not_found': imageNotFound,
    'gallery_permission_denied': galleryPermissionDenied,
    'failed_to_pick_image': failedToPickImage,
    'no_image_selected': noImageSelected,
    'failed_to_load_settings': failedToLoadSettings,
    'failed_to_save_settings': failedToSaveSettings,
    'invalid_settings_format': invalidSettingsFormat,
    'invalid_folder_path': invalidFolderPath,
    'empty_file_name': emptyFileName,
    'invalid_file_name': invalidFileName,
    'file_already_exists': fileAlreadyExists,
    'invalid_input': invalidInput,
    'permission_denied': permissionDenied,
    'permission_permanently_denied': permissionPermanentlyDenied,
    'failed_to_get_app_version': failedToGetAppVersion,
    'failed_to_open_app_settings': failedToOpenAppSettings,
  };
}