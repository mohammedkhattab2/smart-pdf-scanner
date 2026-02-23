# Smart PDF Scanner – Basic  
## Project Architecture Overview

This document describes the **Clean Architecture** and infrastructure of the Smart PDF Scanner – Basic app.

---

## 1. Layers and Responsibilities

### 1.1 Presentation Layer

Location: `lib/features/scanner/presentation/`

Responsible for:

- Flutter UI (screens/pages).
- `Cubit` state management.
- Reacting to states and triggering use cases.
- No direct access to plugins or platform APIs.

Key files:

- Root app:
  - [`MyApp`](lib/app.dart:11)
  - Entry point [`main.dart`](lib/main.dart:1)

- Scanner (camera + crop) states and cubit:
  - [`ScannerState`](lib/features/scanner/presentation/cubit/scanner_state.dart:7)
  - [`ScannerCubit`](lib/features/scanner/presentation/cubit/scanner_cubit.dart:13)

- PDF generation states and cubit:
  - [`PdfGenerationState`](lib/features/scanner/presentation/cubit/pdf_generation_state.dart:7)
  - [`PdfGenerationCubit`](lib/features/scanner/presentation/cubit/pdf_generation_cubit.dart:18)

- PDF list states and cubit:
  - [`PdfListState`](lib/features/scanner/presentation/cubit/pdf_list_state.dart:7)
  - [`PdfListCubit`](lib/features/scanner/presentation/cubit/pdf_list_cubit.dart:14)

- Main screen:
  - [`ScannerHomePage`](lib/features/scanner/presentation/pages/scanner_home_page.dart:15)  
    - Shows list of PDFs.
    - FAB to start scan flow.
    - Calls:
      - `PdfListCubit.loadPdfs()`
      - `PdfListCubit.openDocument()`
      - `PdfListCubit.shareDocument()`
      - `ScannerCubit.reset()` before navigation to scan flow.

> Camera page and crop page are intended as additional presentation widgets that use `ScannerCubit` + `PdfGenerationCubit`.

---

### 1.2 Domain Layer

Location: `lib/features/scanner/domain/`

Responsible for:

- Business rules (pure Dart).
- Entities.
- Abstract repositories.
- Use cases (application-specific actions).

#### 1.2.1 Entity

- [`ScannedDocument`](lib/features/scanner/domain/entities/scanned_document.dart:5)
  - Fields: `id`, `fileName`, `filePath`, `createdAt`.
  - Extends `Equatable` for value equality.

#### 1.2.2 Repository Abstraction

- [`ScannerRepository`](lib/features/scanner/domain/repositories/scanner_repository.dart:11)

Responsibilities:

- Camera:
  - `captureDocument() -> Either<Failure, String>`
- Crop:
  - `cropDocumentImage(String imagePath)`
- PDF generation:
  - `generatePdfFromImage(String imagePath) -> Uint8List`
- Storage:
  - `savePdf({pdfBytes, suggestedName}) -> ScannedDocument`
  - `getSavedPdfs() -> List<ScannedDocument>`
- Open:
  - `openPdf(ScannedDocument) -> Unit`
- Share:
  - `sharePdf(ScannedDocument) -> Unit`

#### 1.2.3 Use Cases

Base class:

- [`UseCase<Type, Params>`](lib/core/usecases/usecase.dart:5)
- [`NoParams`](lib/core/usecases/usecase.dart:14)

Scanner use cases:

- Capture:
  - [`CaptureDocumentUseCase`](lib/features/scanner/domain/usecases/capture_document_usecase.dart:8)

- Crop:
  - [`CropDocumentImageUseCase`](lib/features/scanner/domain/usecases/crop_document_image_usecase.dart:17)  
    - Params: [`CropDocumentImageParams`](lib/features/scanner/domain/usecases/crop_document_image_usecase.dart:8)

- Generate PDF:
  - [`GeneratePdfFromImageUseCase`](lib/features/scanner/domain/usecases/generate_pdf_from_image_usecase.dart:18)  
    - Params: [`GeneratePdfFromImageParams`](lib/features/scanner/domain/usecases/generate_pdf_from_image_usecase.dart:10)

- Save PDF:
  - [`SavePdfUseCase`](lib/features/scanner/domain/usecases/save_pdf_usecase.dart:24)  
    - Params: [`SavePdfParams`](lib/features/scanner/domain/usecases/save_pdf_usecase.dart:12)

- List PDFs:
  - [`GetSavedPdfsUseCase`](lib/features/scanner/domain/usecases/get_saved_pdfs_usecase.dart:9)

- Open PDF:
  - [`OpenPdfUseCase`](lib/features/scanner/domain/usecases/open_pdf_usecase.dart:16)  
    - Params: [`OpenPdfParams`](lib/features/scanner/domain/usecases/open_pdf_usecase.dart:9)

- Share PDF:
  - [`SharePdfUseCase`](lib/features/scanner/domain/usecases/share_pdf_usecase.dart:16)  
    - Params: [`SharePdfParams`](lib/features/scanner/domain/usecases/share_pdf_usecase.dart:9)

#### 1.2.4 Failures

Location: `lib/core/errors/`

- Base failure:
  - [`Failure`](lib/core/errors/failures.dart:1)

- Domain-specific failures:
  - `CameraFailure`
  - `FileSaveFailure`
  - `FileReadFailure`
  - `FileOpenFailure`
  - `ShareFailure`
  - `UnexpectedFailure`

Use cases always return `Either<Failure, T>` instead of throwing exceptions.

---

### 1.3 Data Layer

Location: `lib/features/scanner/data/`

Responsible for:

- Working with plugins and platform APIs.
- Mapping data to/from domain entities.
- Implementing repositories.

#### 1.3.1 Models

- [`ScannedDocumentModel`](lib/features/scanner/data/models/scanned_document_model.dart:7)
  - Converts:
    - `fromFile(FileSystemEntity)`
    - `toEntity()`
    - `fromEntity(ScannedDocument)`

#### 1.3.2 DataSources

- Camera:
  - [`CameraDataSource`](lib/features/scanner/data/datasources/camera_data_source.dart:11)
  - [`CameraDataSourceImpl`](lib/features/scanner/data/datasources/camera_data_source.dart:23)
    - Uses `camera` plugin to capture image and return path.

- Image cropper:
  - [`ImageCropperDataSource`](lib/features/scanner/data/datasources/image_cropper_data_source.dart:11)
  - [`ImageCropperDataSourceImpl`](lib/features/scanner/data/datasources/image_cropper_data_source.dart:21)
    - Uses `image_cropper` with `AndroidUiSettings` and `IOSUiSettings`.

- PDF generator:
  - [`PdfGeneratorDataSource`](lib/features/scanner/data/datasources/pdf_generator_data_source.dart:12)
  - [`PdfGeneratorDataSourceImpl`](lib/features/scanner/data/datasources/pdf_generator_data_source.dart:20)
    - Uses `pdf` to generate single-page PDF from an image file.

- Local storage:
  - [`LocalPdfStorageDataSource`](lib/features/scanner/data/datasources/local_pdf_storage_data_source.dart:14)
  - [`LocalPdfStorageDataSourceImpl`](lib/features/scanner/data/datasources/local_pdf_storage_data_source.dart:30)
    - Uses `path_provider` to create `scanned_pdfs` directory.
    - Saves `.pdf` files and lists them back as models.

- Open file:
  - [`PdfOpenerDataSource`](lib/features/scanner/data/datasources/pdf_opener_data_source.dart:8)
  - [`PdfOpenerDataSourceImpl`](lib/features/scanner/data/datasources/pdf_opener_data_source.dart:18)
    - Uses `open_file` to open PDFs with default system viewer.

- Share file:
  - [`PdfSharingDataSource`](lib/features/scanner/data/datasources/pdf_sharing_data_source.dart:7)
  - [`PdfSharingDataSourceImpl`](lib/features/scanner/data/datasources/pdf_sharing_data_source.dart:17)
    - Uses `share_plus` and `XFile` to share PDFs.

#### 1.3.3 Repository Implementation

- [`ScannerRepositoryImpl`](lib/features/scanner/data/repositories/scanner_repository_impl.dart:15)
  - Injected with all data sources.
  - Maps plugin exceptions to `Failure` types.
  - Converts `ScannedDocumentModel` to `ScannedDocument`.

---

## 2. Dependency Injection

Location: [`injection_container.dart`](lib/injection_container.dart:1)

- Simple custom service locator:
  - [`ServiceLocator`](lib/injection_container.dart:21)
  - Global helper: [`sl<T>()`](lib/injection_container.dart:47)

- Init method:
  - [`init()`](lib/injection_container.dart:55)
    - Registers:
      - DataSources:
        - `CameraDataSourceImpl`
        - `ImageCropperDataSourceImpl`
        - `PdfGeneratorDataSourceImpl`
        - `LocalPdfStorageDataSourceImpl`
        - `PdfOpenerDataSourceImpl`
        - `PdfSharingDataSourceImpl`
      - Repository:
        - `ScannerRepositoryImpl` as `ScannerRepository`
      - UseCases:
        - `CaptureDocumentUseCase`
        - `CropDocumentImageUseCase`
        - `GeneratePdfFromImageUseCase`
        - `SavePdfUseCase`
        - `GetSavedPdfsUseCase`
        - `OpenPdfUseCase`
        - `SharePdfUseCase`
      - Cubits:
        - `ScannerCubit`
        - `PdfGenerationCubit`
        - `PdfListCubit`

---

## 3. Packages and Platform Integration

Configured in [`pubspec.yaml`](pubspec.yaml:30):

- `flutter_bloc` – Cubit/Bloc state management.
- `equatable` – value equality for states/entities.
- `dartz` – `Either` / `Unit`.
- `camera` – capture images.
- `image_cropper` – crop images.
- `pdf` – generate PDF.
- `path_provider` – app documents directory.
- `open_file` – open files with system apps.
- `share_plus` – share files.

Android / iOS permissions should be configured in:

- Android: [`AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml:1)
- iOS: [`Info.plist`](ios/Runner/Info.plist:1)

---

## 4. High-level Flow

1. **Home** (`ScannerHomePage`):
   - Loads list of PDFs via `PdfListCubit.loadPdfs()`.
   - Shows list or empty/error state.

2. **Scan**:
   - User taps FAB.
   - `ScannerCubit` is reset.
   - UI navigates to camera page (to be implemented).
   - `ScannerCubit.captureDocument()` called → `ScannerCaptured(imagePath)`.

3. **Crop**:
   - UI calls `ScannerCubit.cropDocument(imagePath)` →
     `ScannerCropped(croppedImagePath)`.

4. **Generate + Save PDF**:
   - UI calls `PdfGenerationCubit.generateAndSave(imagePath, suggestedName)`:
     - Generate PDF bytes.
     - Save PDF file.
     - Emit `PdfGenerationSuccess(ScannedDocument)`.

5. **Back to list**:
   - UI pops back to `ScannerHomePage`.
   - `PdfListCubit.loadPdfs()` refreshes list including the new document.

6. **Open / Share**:
   - Tap item → `PdfListCubit.openDocument(doc)` → System viewer.
   - Tap share icon → `PdfListCubit.shareDocument(doc)` → System share sheet.
