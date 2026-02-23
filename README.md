# Smart PDF Scanner – Basic 📄

A lightweight, production-ready **document scanning** app built with **Flutter**, designed as part of the **Smart Tools** series.

This is a **Basic MVP** focused on fast Play Store approval and a clean architecture foundation that can be extended later with Pro features.

---

## Overview

**Smart PDF Scanner – Basic** allows users to:

- Scan documents using the device **camera**
- **Crop** captured images
- Convert images to **PDF**
- **Save** PDFs locally in an app-specific directory
- **View** saved PDFs in a simple list
- **Share** PDFs via installed apps (WhatsApp, Gmail, Google Drive, etc.)

Intentionally **not included** in this MVP:

- OCR (text recognition)
- PDF merge/split
- Cloud sync / backup
- Password-protected PDFs
- Ads or monetization

---

## Features

- 📷 **Scan Documents**
  - Capture documents using the built-in camera.
- ✂️ **Crop Images**
  - Adjust document boundaries using a native crop UI.
- 📄 **Generate PDFs**
  - Convert a single image into a one-page PDF.
- 💾 **Local Storage**
  - Save generated PDFs into an app-specific folder.
- 📚 **View Saved PDFs**
  - Display a list of all scanned documents with basic metadata.
- 📤 **Share PDFs**
  - Share PDFs through system share sheet (WhatsApp, Gmail, Drive, etc.).

---

## Screens & User Flow

**User Flow (MVP)**:

1. **Home Screen**
   - Shows a list of saved PDFs.
   - Floating Action Button (FAB) to start a new scan.
2. **Camera Flow**
   - User captures a photo of the document.
3. **Crop Flow**
   - User crops the captured image to focus on the document.
4. **PDF Generation & Save**
   - Cropped image is converted to PDF and saved locally.
5. **Back to Home**
   - List is refreshed to include the new PDF.
   - User can **open** or **share** any existing document.

> Note: The UI is intentionally minimal and clean, suitable for a basic scanner app and easy Play Store approval.

---

## Architecture

The project follows **Clean Architecture**:

- **Presentation Layer**
  - Flutter UI (screens, widgets).
  - State management with **flutter_bloc** using **Cubit**.
- **Domain Layer**
  - **Entities** (core business models, e.g. `ScannedDocument`).
  - **UseCases** (application-specific actions: capture, crop, generate, save, list, open, share).
  - **Repository abstractions** (interfaces).
- **Data Layer**
  - **Models** (mapping between raw data and domain entities).
  - **DataSources** (camera, crop, PDF generator, local storage, open, share).
  - **Repository implementations** (bridge Domain & Data).

Each feature Cubit uses clear, immutable states:

- `Initial`
- `Loading`
- `Success`
- `Error`

Error handling is centralized using a `Failure` model in the domain layer (no exceptions thrown into the UI).

---

## Folder Structure

```text
lib/
  core/
    errors/
      failures.dart
    usecases/
      usecase.dart
    theme/
      app_theme.dart

  features/
    scanner/
      presentation/
        pages/
          scanner_home_page.dart
          # (CameraPage and ImageCropPage to be added)
        cubit/
          scanner_cubit.dart
          scanner_state.dart
          pdf_generation_cubit.dart
          pdf_generation_state.dart
          pdf_list_cubit.dart
          pdf_list_state.dart

      domain/
        entities/
          scanned_document.dart
        repositories/
          scanner_repository.dart
        usecases/
          capture_document_usecase.dart
          crop_document_image_usecase.dart
          generate_pdf_from_image_usecase.dart
          save_pdf_usecase.dart
          get_saved_pdfs_usecase.dart
          open_pdf_usecase.dart
          share_pdf_usecase.dart

      data/
        models/
          scanned_document_model.dart
        datasources/
          camera_data_source.dart
          image_cropper_data_source.dart
          pdf_generator_data_source.dart
          local_pdf_storage_data_source.dart
          pdf_opener_data_source.dart
          pdf_sharing_data_source.dart
        repositories/
          scanner_repository_impl.dart

  app.dart
  injection_container.dart
  main.dart
```

---

## Tech Stack

- **Flutter**
- **Clean Architecture**
- **State Management**
  - `flutter_bloc` (Cubit)
- **Camera & Media**
  - `camera`
  - `image_cropper`
- **PDF**
  - `pdf`
- **Storage**
  - `path_provider`
- **Sharing & Opening Files**
  - `share_plus`
  - `open_file`
- **Support / Utilities**
  - `equatable` – value equality for states/entities
  - `dartz` – `Either`, `Unit` for functional error handling

---

## Getting Started

### Prerequisites

- Flutter SDK installed (3.x+ recommended).
- Android Studio or VS Code with Flutter/Dart plugins.
- Android device or emulator.
- (Optional) Xcode + iOS device/simulator if targeting iOS.

### Clone the Repository

```bash
git clone https://github.com/your-username/smart_pdf_scanner_basic.git
cd smart_pdf_scanner_basic
```

### Install Dependencies

```bash
flutter pub get
```

---

## Running the Project

### On Android

1. Connect a physical device or start an Android emulator.
2. Run:

```bash
flutter run
```

3. Select the desired Android device when prompted.

### On iOS (Optional)

1. Open the `ios` folder in Xcode and configure signing if needed.
2. Then:

```bash
flutter run
```

> Note: Some camera/cropper behaviors may differ between platforms; Android is the primary target for this MVP.

---

## Android Permissions

Add the following to your **AndroidManifest.xml** (if not already configured):

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    tools:remove="android:maxSdkVersion" />
```

And declare camera feature (optional but recommended):

```xml
<uses-feature android:name="android.hardware.camera" />
<uses-feature android:name="android.hardware.camera.autofocus" />
```

Runtime behavior:

- The app should request camera permission at runtime when starting a scan.
- If the user denies permission, the app should fail gracefully with a user-friendly message (not a crash).

---

## Future Improvements

Planned / potential enhancements for a **Pro** version:

- 🔤 **OCR Integration**
  - Extract text from scanned images.
- ☁️ **Cloud Sync**
  - Sync documents with cloud storage (e.g. Supabase, Firebase, etc.).
- 🧩 **Advanced PDF Operations**
  - Merge multiple PDFs, split pages, reorder, etc.
- 🔐 **Security**
  - Password-protected PDFs and encrypted storage.
- 🎨 **UI/UX Enhancements**
  - Better document edge detection, filters, multi-page scans.
- 🧪 **More Automated Tests**
  - Deeper use case, repository, and widget/bloc tests.

---

## Status

- **Status:** MVP in development 🚧
- Focus:
  - Stable scanning → PDF → local save → open → share flow.
  - Clean and maintainable architecture ready for future expansion.

---

## Author

**Smart Tools Series – Smart PDF Scanner – Basic**

- Role: Senior Flutter Developer / Technical Writer
- Focus:
  - Clean, scalable architecture.
  - Production-friendly MVPs.
  - Codebases that are easy to extend with Pro features.

If you use this project as a starter, you can:

- Replace the GitHub URL with your own.
- Add your name, contact info, and links (LinkedIn, portfolio, etc.) in this section.
