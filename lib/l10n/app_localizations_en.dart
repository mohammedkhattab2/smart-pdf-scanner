// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Smart PDF Scanner';

  @override
  String get scanDocument => 'Scan Document';

  @override
  String get fromCamera => 'From Camera';

  @override
  String get fromGallery => 'From Gallery';

  @override
  String get recentScans => 'Recent Scans';

  @override
  String get noScansYet => 'No scans yet';

  @override
  String get startScanning => 'Start scanning to see your documents here';

  @override
  String get delete => 'Delete';

  @override
  String get share => 'Share';

  @override
  String get open => 'Open';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get pdfQuality => 'PDF Quality';

  @override
  String get low => 'Low';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'High';

  @override
  String get defaultSavePath => 'Default Save Path';

  @override
  String get selectFolder => 'Select Folder';

  @override
  String get autoEnhance => 'Auto Enhance Images';

  @override
  String get appVersion => 'App Version';

  @override
  String get about => 'About';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get rateApp => 'Rate App';

  @override
  String get shareApp => 'Share App';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get crop => 'Crop';

  @override
  String get rotate => 'Rotate';

  @override
  String get enhance => 'Enhance';

  @override
  String get fileName => 'File Name';

  @override
  String get enterFileName => 'Enter file name';

  @override
  String get processing => 'Processing...';

  @override
  String get generatingPdf => 'Generating PDF...';

  @override
  String get savingPdf => 'Saving PDF...';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Info';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteMessage => 'Are you sure you want to delete this PDF?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get cameraPermissionMessage =>
      'Camera permission is required to scan documents';

  @override
  String get storagePermissionMessage =>
      'Storage permission is required to save documents';

  @override
  String get galleryPermissionMessage =>
      'Gallery permission is required to pick images';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get scanner => 'Scanner';

  @override
  String get premium => 'PREMIUM';

  @override
  String get noDocumentsYet => 'No Documents Yet';

  @override
  String get tapToScan =>
      'Tap the golden button below to\nscan your first document';

  @override
  String get deleteDocument => 'Delete Document?';

  @override
  String get deleteDocumentMessage => 'This action cannot be undone';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '$count minutes ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get general => 'General';

  @override
  String get pdfSettings => 'PDF Settings';

  @override
  String get autoEnhanceSubtitle => 'Automatically improve image quality';

  @override
  String get version => 'Version';

  @override
  String get email => 'Email';

  @override
  String get responseTime => 'Response Time';

  @override
  String get within24Hours => 'Within 24 hours';

  @override
  String get sendQuickMessage => 'Send a Quick Message';

  @override
  String get subject => 'Subject';

  @override
  String get enterSubject => 'Enter message subject';

  @override
  String get yourMessage => 'Your Message';

  @override
  String get describeIssue =>
      'Describe your issue or ask your question here...';

  @override
  String get sendEmail => 'Send Email';

  @override
  String get faq => 'Frequently Asked Questions';

  @override
  String get faqSavePdf => 'How do I save a PDF file?';

  @override
  String get faqSavePdfAnswer =>
      'After capturing or importing an image and editing it, tap the \"Save as PDF\" button.';

  @override
  String get faqEditPdf => 'Can I edit existing PDF files?';

  @override
  String get faqEditPdfAnswer =>
      'Currently, the app only supports creating new PDF files from images.';

  @override
  String get faqSaveLocation => 'Where are PDF files saved?';

  @override
  String get faqSaveLocationAnswer =>
      'All files are saved in the app\'s private folder on your device.';

  @override
  String get emailCopied => 'Email copied to clipboard';

  @override
  String get couldNotOpenEmail => 'Could not open email app';

  @override
  String get fillAllFields => 'Please fill all fields';

  @override
  String get weAreHereToHelp => 'We\'re here to help! Get in touch';
}
