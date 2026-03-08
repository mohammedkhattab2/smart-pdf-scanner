
import 'package:shared_preferences/shared_preferences.dart';

import 'features/scanner/data/datasources/camera_data_source.dart';
import 'features/scanner/data/datasources/gallery_data_source.dart';
import 'features/scanner/data/datasources/image_cropper_data_source.dart';
import 'features/scanner/data/datasources/local_pdf_storage_data_source.dart';
import 'features/scanner/data/datasources/pdf_generator_data_source.dart';
import 'features/scanner/data/datasources/pdf_opener_data_source.dart';
import 'features/scanner/data/datasources/pdf_sharing_data_source.dart';
import 'features/scanner/data/repositories/scanner_repository_impl.dart';
import 'features/scanner/domain/repositories/scanner_repository.dart';
import 'features/scanner/domain/usecases/capture_document_usecase.dart';
import 'features/scanner/domain/usecases/crop_document_image_usecase.dart';
import 'features/scanner/domain/usecases/generate_pdf_from_image_usecase.dart';
import 'features/scanner/domain/usecases/get_saved_pdfs_usecase.dart';
import 'features/scanner/domain/usecases/open_pdf_usecase.dart';
import 'features/scanner/domain/usecases/pick_image_from_gallery_usecase.dart';
import 'features/scanner/domain/usecases/save_pdf_usecase.dart';
import 'features/scanner/domain/usecases/share_pdf_usecase.dart';
import 'features/scanner/domain/usecases/delete_pdf_usecase.dart';
import 'features/scanner/presentation/cubit/pdf_generation_cubit.dart';
import 'features/scanner/presentation/cubit/pdf_list_cubit.dart';
import 'features/scanner/presentation/cubit/scanner_cubit.dart';
import 'features/settings/data/datasources/settings_local_data_source.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/get_settings_usecase.dart';
import 'features/settings/domain/usecases/save_settings_usecase.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/app_theme_cubit.dart';

/// Very simple manual service locator.
///
/// This is intentionally minimal and does not rely on any external DI package.
/// It stores factories for types and can resolve them at runtime using [get].
class ServiceLocator {
  ServiceLocator._internal();

  static final ServiceLocator instance = ServiceLocator._internal();

  final Map<Type, dynamic Function()> _factories = {};

  /// Register a factory for type [T].
  void registerFactory<T>(T Function() factory) {
    _factories[T] = factory;
  }

  /// Register a lazy singleton for type [T].
  void registerLazySingleton<T>(T Function() factory) {
    T? instance;
    _factories[T] = () {
      instance ??= factory();
      return instance!;
    };
  }

  /// Resolve an instance of type [T].
  T get<T>() {
    final factory = _factories[T];
    if (factory == null) {
      throw StateError('Type $T has not been registered in ServiceLocator');
    }
    return factory() as T;
  }
}

/// Global shorthand used across the app, e.g. `sl<MyType>()`.
T sl<T>() => ServiceLocator.instance.get<T>();

/// Initialize dependency graph for the whole application.
///
/// This function is called from `main()` before `runApp`.
Future<void> init() async {
  final locator = ServiceLocator.instance;
  
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);

  // ================
  // Data sources
  // ================
  locator.registerLazySingleton<CameraDataSource>(
    () => CameraDataSourceImpl(),
  );
  
  locator.registerLazySingleton<GalleryDataSource>(
    () => GalleryDataSourceImpl(),
  );

  locator.registerLazySingleton<ImageCropperDataSource>(
    () => ImageCropperDataSourceImpl(),
  );

  locator.registerLazySingleton<PdfGeneratorDataSource>(
    () => PdfGeneratorDataSourceImpl(),
  );

  locator.registerLazySingleton<LocalPdfStorageDataSource>(
    () => LocalPdfStorageDataSourceImpl(),
  );

  locator.registerLazySingleton<PdfOpenerDataSource>(
    () => PdfOpenerDataSourceImpl(),
  );

  locator.registerLazySingleton<PdfSharingDataSource>(
    () => PdfSharingDataSourceImpl(),
  );
  
  // Settings data sources
  locator.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(
      sharedPreferences: locator.get(),
    ),
  );

  // ================
  // Repositories
  // ================
  locator.registerLazySingleton<ScannerRepository>(
    () => ScannerRepositoryImpl(
      cameraDataSource: locator.get<CameraDataSource>(),
      galleryDataSource: locator.get<GalleryDataSource>(),
      imageCropperDataSource: locator.get<ImageCropperDataSource>(),
      pdfGeneratorDataSource: locator.get<PdfGeneratorDataSource>(),
      localPdfStorageDataSource: locator.get<LocalPdfStorageDataSource>(),
      pdfOpenerDataSource: locator.get<PdfOpenerDataSource>(),
      pdfSharingDataSource: locator.get<PdfSharingDataSource>(),
    ),
  );
  
  locator.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      localDataSource: locator.get<SettingsLocalDataSource>(),
    ),
  );

  // ================
  // Use cases
  // ================
  locator.registerLazySingleton<CaptureDocumentUseCase>(
    () => CaptureDocumentUseCase(locator.get<ScannerRepository>()),
  );

  locator.registerLazySingleton<CropDocumentImageUseCase>(
    () => CropDocumentImageUseCase(locator.get<ScannerRepository>()),
  );

  locator.registerLazySingleton<GeneratePdfFromImageUseCase>(
    () => GeneratePdfFromImageUseCase(locator.get<ScannerRepository>()),
  );

  locator.registerLazySingleton<SavePdfUseCase>(
    () => SavePdfUseCase(locator.get<ScannerRepository>()),
  );

  locator.registerLazySingleton<GetSavedPdfsUseCase>(
    () => GetSavedPdfsUseCase(locator.get<ScannerRepository>()),
  );

  locator.registerLazySingleton<OpenPdfUseCase>(
    () => OpenPdfUseCase(locator.get<ScannerRepository>()),
  );

  locator.registerLazySingleton<SharePdfUseCase>(
    () => SharePdfUseCase(locator.get<ScannerRepository>()),
  );
  
  locator.registerLazySingleton<DeletePdfUseCase>(
    () => DeletePdfUseCase(locator.get<ScannerRepository>()),
  );
  
  locator.registerLazySingleton<PickImageFromGalleryUseCase>(
    () => PickImageFromGalleryUseCase(locator.get<ScannerRepository>()),
  );
  
  // Settings use cases
  locator.registerLazySingleton<GetSettingsUseCase>(
    () => GetSettingsUseCase(locator.get<SettingsRepository>()),
  );
  
  locator.registerLazySingleton<SaveSettingsUseCase>(
    () => SaveSettingsUseCase(locator.get<SettingsRepository>()),
  );

  // ================
  // Cubits
  // ================
  locator.registerFactory<ScannerCubit>(
    () => ScannerCubit(
      captureDocumentUseCase: locator.get<CaptureDocumentUseCase>(),
      cropDocumentImageUseCase: locator.get<CropDocumentImageUseCase>(),
    ),
  );

  locator.registerFactory<PdfGenerationCubit>(
    () => PdfGenerationCubit(
      generatePdfFromImageUseCase:
          locator.get<GeneratePdfFromImageUseCase>(),
      savePdfUseCase: locator.get<SavePdfUseCase>(),
    ),
  );

  locator.registerFactory<PdfListCubit>(
    () => PdfListCubit(
      getSavedPdfsUseCase: locator.get<GetSavedPdfsUseCase>(),
      openPdfUseCase: locator.get<OpenPdfUseCase>(),
      sharePdfUseCase: locator.get<SharePdfUseCase>(),
      deletePdfUseCase: locator.get<DeletePdfUseCase>(),
    ),
  );
  
  locator.registerFactory<SettingsCubit>(
    () => SettingsCubit(
      getSettings: locator.get<GetSettingsUseCase>(),
      saveSettings: locator.get<SaveSettingsUseCase>(),
    ),
  );
  
  locator.registerFactory<AppThemeCubit>(
    () => AppThemeCubit(),
  );
}