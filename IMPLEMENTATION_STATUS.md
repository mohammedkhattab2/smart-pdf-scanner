# Smart PDF Scanner – Basic  
## Implementation Status

This document tracks **what is already implemented** in the project and **what is still pending** for the MVP.

---

## 1. Implemented

### 1.1 Project Setup

- Flutter project created: `smart_pdf_scanner`.
- Dependencies added in [`pubspec.yaml`](pubspec.yaml:30):
  - `flutter_bloc`
  - `equatable`
  - `dartz`
  - `camera`
  - `image_cropper`
  - `pdf`
  - `path_provider`
  - `open_file`
  - `share_plus`
- `flutter pub get` executed successfully.

---

### 1.2 Core / Shared

- Error model:
  - [`Failure` + specific failures](lib/core/errors/failures.dart:1)

- Base use case:
  - [`UseCase<Type, Params>` and `NoParams`](lib/core/usecases/usecase.dart:5)

- App theme:
  - [`AppTheme.lightTheme`](lib/core/theme/app_theme.dart:8)

---

### 1.3 Domain Layer

**Entity**

- [`ScannedDocument`](lib/features/scanner/domain/entities/scanned_document.dart:5)

**Repository abstraction**

- [`ScannerRepository`](lib/features/scanner/domain/repositories/scanner_repository.dart:11)

**Use Cases**

- Capture:
  - [`CaptureDocumentUseCase`](lib/features/scanner/domain/usecases/capture_document_usecase.dart:8)

- Crop:
  - [`CropDocumentImageUseCase`](lib/features/scanner/domain/usecases/crop_document_image_usecase.dart:17)

- Generate PDF:
  - [`GeneratePdfFromImageUseCase`](lib/features/scanner/domain/usecases/generate_pdf_from_image_usecase.dart:18)

- Save PDF:
  - [`SavePdfUseCase`](lib/features/scanner/domain/usecases/save_pdf_usecase.dart:24)

- Get list:
  - [`GetSavedPdfsUseCase`](lib/features/scanner/domain/usecases/get_saved_pdfs_usecase.dart:9)

- Open:
  - [`OpenPdfUseCase`](lib/features/scanner/domain/usecases/open_pdf_usecase.dart:16)

- Share:
  - [`SharePdfUseCase`](lib/features/scanner/domain/usecases/share_pdf_usecase.dart:16)

---

### 1.4 Data Layer

**Model**

- [`ScannedDocumentModel`](lib/features/scanner/data/models/scanned_document_model.dart:7)

**DataSources**

- Camera:
  - [`CameraDataSource`](lib/features/scanner/data/datasources/camera_data_source.dart:11)
  - [`CameraDataSourceImpl`](lib/features/scanner/data/datasources/camera_data_source.dart:23)

- Crop:
  - [`ImageCropperDataSource`](lib/features/scanner/data/datasources/image_cropper_data_source.dart:11)
  - [`ImageCropperDataSourceImpl`](lib/features/scanner/data/datasources/image_cropper_data_source.dart:21)

- PDF generation:
  - [`PdfGeneratorDataSource`](lib/features/scanner/data/datasources/pdf_generator_data_source.dart:12)
  - [`PdfGeneratorDataSourceImpl`](lib/features/scanner/data/datasources/pdf_generator_data_source.dart:20)

- Local storage:
  - [`LocalPdfStorageDataSource`](lib/features/scanner/data/datasources/local_pdf_storage_data_source.dart:14)
  - [`LocalPdfStorageDataSourceImpl`](lib/features/scanner/data/datasources/local_pdf_storage_data_source.dart:30)

- Open file:
  - [`PdfOpenerDataSource`](lib/features/scanner/data/datasources/pdf_opener_data_source.dart:8)
  - [`PdfOpenerDataSourceImpl`](lib/features/scanner/data/datasources/pdf_opener_data_source.dart:18)

- Share file:
  - [`PdfSharingDataSource`](lib/features/scanner/data/datasources/pdf_sharing_data_source.dart:7)
  - [`PdfSharingDataSourceImpl`](lib/features/scanner/data/datasources/pdf_sharing_data_source.dart:17)

**Repository implementation**

- [`ScannerRepositoryImpl`](lib/features/scanner/data/repositories/scanner_repository_impl.dart:15)

---

### 1.5 Presentation Layer

**Scanner (camera + crop) Cubit**

- States:
  - [`ScannerState`](lib/features/scanner/presentation/cubit/scanner_state.dart:7)  
    - `ScannerInitial`, `ScannerLoading`, `ScannerCaptured`, `ScannerCropped`, `ScannerError`.
- Cubit:
  - [`ScannerCubit`](lib/features/scanner/presentation/cubit/scanner_cubit.dart:13)

**PDF generation Cubit**

- States:
  - [`PdfGenerationState`](lib/features/scanner/presentation/cubit/pdf_generation_state.dart:7)  
    - `PdfGenerationInitial`, `PdfGenerationLoading`, `PdfGenerationSuccess`, `PdfGenerationError`.
- Cubit:
  - [`PdfGenerationCubit`](lib/features/scanner/presentation/cubit/pdf_generation_cubit.dart:18)

**PDF list Cubit**

- States:
  - [`PdfListState`](lib/features/scanner/presentation/cubit/pdf_list_state.dart:7)  
    - `PdfListInitial`, `PdfListLoading`, `PdfListLoaded`, `PdfListError`.
- Cubit:
  - [`PdfListCubit`](lib/features/scanner/presentation/cubit/pdf_list_cubit.dart:14)

**Screens**

- Home:
  - [`ScannerHomePage`](lib/features/scanner/presentation/pages/scanner_home_page.dart:15)  
    - Shows list of PDFs.
    - Uses `PdfListCubit` for:
      - Loading list.
      - Opening PDFs.
      - Sharing PDFs.
    - FAB prepared to start the scan flow (navigation TODO).

> Camera and crop screens not yet created as separate pages.

---

### 1.6 Dependency Injection

- Service locator + global accessor:
  - [`ServiceLocator`](lib/injection_container.dart:21)
  - [`sl<T>()`](lib/injection_container.dart:47)

- Initialization:
  - [`init()`](lib/injection_container.dart:55)  
    - Registers:
      - All scanner DataSources (camera, cropper, PDF generator, storage, opener, sharing).
      - [`ScannerRepositoryImpl`](lib/features/scanner/data/repositories/scanner_repository_impl.dart:15) as [`ScannerRepository`](lib/features/scanner/domain/repositories/scanner_repository.dart:11).
      - All scanner UseCases.
      - All scanner Cubits.

---

### 1.7 Tests

- Basic smoke test:
  - [`widget_test.dart`](test/widget_test.dart:5)  
    - Pumps `MyApp`.
    - Checks AppBar title `Smart PDF Scanner`.

---

## 2. Still To Do (TODO List)

### 2.1 UI / UX

- [ ] **CameraPage**
  - A screen that:
    - Shows camera preview (using `camera` plugin).
    - Calls `ScannerCubit.captureDocument()`.
    - On `ScannerCaptured` state:
      - Navigate to the crop page with captured image path.

- [ ] **ImageCropPage**
  - A screen that:
    - Receives image path (from camera page).
    - Calls `ScannerCubit.cropDocument(imagePath)`.
    - On `ScannerCropped` state:
      - Calls `PdfGenerationCubit.generateAndSave()` with:
        - Cropped image path.
        - Suggested file name.
      - On `PdfGenerationSuccess`:
        - Pop back to `ScannerHomePage`.
        - Trigger `PdfListCubit.loadPdfs()` to refresh list.

- [ ] Improve UI/UX for:
  - Error messages and snackbars.
  - Progress indicators during long operations (capture, crop, generate, save).

---

### 2.2 Error Handling & Edge Cases

- [ ] More granular error messages for:
  - Permission denied (camera, storage).
  - No camera available.
  - Low storage.
- [ ] Centralized mapping of plugin errors to `Failure` codes (optional improvement).

---

### 2.3 Permissions & Platform-specific

- [ ] **Android**
  - Add camera and storage-related permissions to:
    - [`AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml:1)
  - Verify behavior on Android 13+ runtime permissions.

- [ ] **iOS** (optional but recommended)
  - Add usage descriptions in:
    - [`Info.plist`](ios/Runner/Info.plist:1)
      - `NSCameraUsageDescription`
      - `NSPhotoLibraryAddUsageDescription` (if needed)

---

### 2.4 Testing

- [ ] Add **unit tests** for:
  - One or more UseCases:
    - `GeneratePdfFromImageUseCase`
    - `SavePdfUseCase`
  - `ScannerRepositoryImpl` behavior with mocked DataSources.

- [ ] Add **bloc tests** for:
  - `ScannerCubit` (success + error paths).
  - `PdfGenerationCubit`.
  - `PdfListCubit`.

- [ ] Extend widget tests to:
  - Interact with FAB and verify loading/list refresh behavior (using fake repository or mocks).

---

### 2.5 Polish and Pro-readiness

- [ ] Review all public class and method names for consistency and clarity.
- [ ] Ensure no debug logs or temporary prints are left in production code.
- [ ] Double-check:
  - All imports are used.
  - No dead code or unused files.
- [ ] Run:
  - `flutter analyze`
  - `flutter test`
- [ ] Manual QA checklist (before Play Store upload):
  - Scan → Crop → PDF → Save → List → Open → Share on at least:
    - One physical Android device.
    - One emulator with different Android version.
  - Permission-denied flow:
    - User denies camera permission → app shows friendly message and guidance.
  - App recovers gracefully from:
    - Missing PDF file.
    - No installed PDF viewer.

---

## 3. Notes for Future Pro Version

(Not for this Basic MVP, but the architecture is prepared for it.)

Possible future extensions:

- OCR:
  - New use cases and repositories built on top of current `ScannedDocument`.
- Cloud Sync:
  - New repository (e.g. `CloudScannerRepository`) implementing a new interface.
  - Sync with remote storage (e.g. Firebase, Supabase, etc.).
- Advanced PDF operations:
  - Merge / split.
  - Password protection.

The current structure (Presentation / Domain / Data + UseCases + Repository abstraction) is designed to accept these features without breaking the existing flows.