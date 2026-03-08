import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Smart PDF Scanner'**
  String get appTitle;

  /// Button text to scan a new document
  ///
  /// In en, this message translates to:
  /// **'Scan Document'**
  String get scanDocument;

  /// Option to capture from camera
  ///
  /// In en, this message translates to:
  /// **'From Camera'**
  String get fromCamera;

  /// Option to pick from gallery
  ///
  /// In en, this message translates to:
  /// **'From Gallery'**
  String get fromGallery;

  /// Header for recent scans section
  ///
  /// In en, this message translates to:
  /// **'Recent Scans'**
  String get recentScans;

  /// Message shown when no scans exist
  ///
  /// In en, this message translates to:
  /// **'No scans yet'**
  String get noScansYet;

  /// Subtitle when no scans exist
  ///
  /// In en, this message translates to:
  /// **'Start scanning to see your documents here'**
  String get startScanning;

  /// Delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Share action
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Open action
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// Cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save action
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme setting
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// PDF quality setting
  ///
  /// In en, this message translates to:
  /// **'PDF Quality'**
  String get pdfQuality;

  /// Low quality option
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// Medium quality option
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// High quality option
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// Default save path setting
  ///
  /// In en, this message translates to:
  /// **'Default Save Path'**
  String get defaultSavePath;

  /// Select folder button
  ///
  /// In en, this message translates to:
  /// **'Select Folder'**
  String get selectFolder;

  /// Auto enhance setting
  ///
  /// In en, this message translates to:
  /// **'Auto Enhance Images'**
  String get autoEnhance;

  /// App version label
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// About section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Privacy policy link
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Terms of service link
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Rate app link
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// Share app link
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// Contact support link
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// Crop action
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get crop;

  /// Rotate action
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get rotate;

  /// Enhance action
  ///
  /// In en, this message translates to:
  /// **'Enhance'**
  String get enhance;

  /// File name field label
  ///
  /// In en, this message translates to:
  /// **'File Name'**
  String get fileName;

  /// File name field hint
  ///
  /// In en, this message translates to:
  /// **'Enter file name'**
  String get enterFileName;

  /// Processing message
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// Generating PDF message
  ///
  /// In en, this message translates to:
  /// **'Generating PDF...'**
  String get generatingPdf;

  /// Saving PDF message
  ///
  /// In en, this message translates to:
  /// **'Saving PDF...'**
  String get savingPdf;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Warning message
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// Info message
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// Delete confirmation title
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// Delete confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this PDF?'**
  String get deleteMessage;

  /// Yes option
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No option
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Permission required title
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// Camera permission message
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to scan documents'**
  String get cameraPermissionMessage;

  /// Storage permission message
  ///
  /// In en, this message translates to:
  /// **'Storage permission is required to save documents'**
  String get storagePermissionMessage;

  /// Gallery permission message
  ///
  /// In en, this message translates to:
  /// **'Gallery permission is required to pick images'**
  String get galleryPermissionMessage;

  /// Grant permission button
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// Open settings button
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Scanner subtitle
  ///
  /// In en, this message translates to:
  /// **'Scanner'**
  String get scanner;

  /// Premium badge text
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get premium;

  /// Empty state title
  ///
  /// In en, this message translates to:
  /// **'No Documents Yet'**
  String get noDocumentsYet;

  /// Empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Tap the golden button below to\nscan your first document'**
  String get tapToScan;

  /// Delete dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Document?'**
  String get deleteDocument;

  /// Delete dialog message
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get deleteDocumentMessage;

  /// Time format - just now
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Time format - minutes ago
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(int count);

  /// Time format - hours ago
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// Time format - yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Time format - days ago
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// General settings section
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// PDF settings section
  ///
  /// In en, this message translates to:
  /// **'PDF Settings'**
  String get pdfSettings;

  /// Auto enhance subtitle
  ///
  /// In en, this message translates to:
  /// **'Automatically improve image quality'**
  String get autoEnhanceSubtitle;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Response time label
  ///
  /// In en, this message translates to:
  /// **'Response Time'**
  String get responseTime;

  /// Response time description
  ///
  /// In en, this message translates to:
  /// **'Within 24 hours'**
  String get within24Hours;

  /// Quick message section title
  ///
  /// In en, this message translates to:
  /// **'Send a Quick Message'**
  String get sendQuickMessage;

  /// Subject field label
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// Subject field hint
  ///
  /// In en, this message translates to:
  /// **'Enter message subject'**
  String get enterSubject;

  /// Message field label
  ///
  /// In en, this message translates to:
  /// **'Your Message'**
  String get yourMessage;

  /// Message field hint
  ///
  /// In en, this message translates to:
  /// **'Describe your issue or ask your question here...'**
  String get describeIssue;

  /// Send email button
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get sendEmail;

  /// FAQ section title
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faq;

  /// FAQ question about saving PDF
  ///
  /// In en, this message translates to:
  /// **'How do I save a PDF file?'**
  String get faqSavePdf;

  /// FAQ answer about saving PDF
  ///
  /// In en, this message translates to:
  /// **'After capturing or importing an image and editing it, tap the \"Save as PDF\" button.'**
  String get faqSavePdfAnswer;

  /// FAQ question about editing PDF
  ///
  /// In en, this message translates to:
  /// **'Can I edit existing PDF files?'**
  String get faqEditPdf;

  /// FAQ answer about editing PDF
  ///
  /// In en, this message translates to:
  /// **'Currently, the app only supports creating new PDF files from images.'**
  String get faqEditPdfAnswer;

  /// FAQ question about save location
  ///
  /// In en, this message translates to:
  /// **'Where are PDF files saved?'**
  String get faqSaveLocation;

  /// FAQ answer about save location
  ///
  /// In en, this message translates to:
  /// **'All files are saved in the app\'s private folder on your device.'**
  String get faqSaveLocationAnswer;

  /// Email copied message
  ///
  /// In en, this message translates to:
  /// **'Email copied to clipboard'**
  String get emailCopied;

  /// Error opening email app
  ///
  /// In en, this message translates to:
  /// **'Could not open email app'**
  String get couldNotOpenEmail;

  /// Validation message for empty fields
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// Support page subtitle
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help! Get in touch'**
  String get weAreHereToHelp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
