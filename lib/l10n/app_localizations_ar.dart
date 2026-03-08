// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'ماسح PDF الذكي';

  @override
  String get scanDocument => 'مسح مستند';

  @override
  String get fromCamera => 'من الكاميرا';

  @override
  String get fromGallery => 'من المعرض';

  @override
  String get recentScans => 'المسح الضوئي الأخير';

  @override
  String get noScansYet => 'لا توجد مستندات ممسوحة بعد';

  @override
  String get startScanning => 'ابدأ المسح الضوئي لرؤية مستنداتك هنا';

  @override
  String get delete => 'حذف';

  @override
  String get share => 'مشاركة';

  @override
  String get open => 'فتح';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get darkTheme => 'داكن';

  @override
  String get systemTheme => 'النظام';

  @override
  String get pdfQuality => 'جودة PDF';

  @override
  String get low => 'منخفضة';

  @override
  String get medium => 'متوسطة';

  @override
  String get high => 'عالية';

  @override
  String get defaultSavePath => 'مسار الحفظ الافتراضي';

  @override
  String get selectFolder => 'اختر مجلد';

  @override
  String get autoEnhance => 'تحسين الصور تلقائياً';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get about => 'حول';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get shareApp => 'مشاركة التطبيق';

  @override
  String get contactSupport => 'اتصل بالدعم';

  @override
  String get crop => 'قص';

  @override
  String get rotate => 'تدوير';

  @override
  String get enhance => 'تحسين';

  @override
  String get fileName => 'اسم الملف';

  @override
  String get enterFileName => 'أدخل اسم الملف';

  @override
  String get processing => 'جاري المعالجة...';

  @override
  String get generatingPdf => 'جاري إنشاء PDF...';

  @override
  String get savingPdf => 'جاري حفظ PDF...';

  @override
  String get success => 'نجح';

  @override
  String get error => 'خطأ';

  @override
  String get warning => 'تحذير';

  @override
  String get info => 'معلومات';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get deleteMessage => 'هل أنت متأكد من رغبتك في حذف هذا الملف؟';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get permissionRequired => 'مطلوب إذن';

  @override
  String get cameraPermissionMessage => 'مطلوب إذن الكاميرا لمسح المستندات';

  @override
  String get storagePermissionMessage => 'مطلوب إذن التخزين لحفظ المستندات';

  @override
  String get galleryPermissionMessage => 'مطلوب إذن المعرض لاختيار الصور';

  @override
  String get grantPermission => 'منح الإذن';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get scanner => 'الماسح الضوئي';

  @override
  String get premium => 'مميز';

  @override
  String get noDocumentsYet => 'لا توجد مستندات حتى الآن';

  @override
  String get tapToScan => 'اضغط على الزر الذهبي أدناه\nلمسح مستندك الأول';

  @override
  String get deleteDocument => 'حذف المستند؟';

  @override
  String get deleteDocumentMessage => 'لا يمكن التراجع عن هذا الإجراء';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(int count) {
    return 'منذ $count دقيقة';
  }

  @override
  String hoursAgo(int count) {
    return 'منذ $count ساعة';
  }

  @override
  String get yesterday => 'أمس';

  @override
  String daysAgo(int count) {
    return 'منذ $count يوم';
  }

  @override
  String get general => 'عام';

  @override
  String get pdfSettings => 'إعدادات PDF';

  @override
  String get autoEnhanceSubtitle => 'تحسين جودة الصور تلقائيًا';

  @override
  String get version => 'الإصدار';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get responseTime => 'وقت الاستجابة';

  @override
  String get within24Hours => 'خلال 24 ساعة';

  @override
  String get sendQuickMessage => 'أرسل رسالة سريعة';

  @override
  String get subject => 'الموضوع';

  @override
  String get enterSubject => 'اكتب موضوع رسالتك';

  @override
  String get yourMessage => 'رسالتك';

  @override
  String get describeIssue => 'اشرح المشكلة أو اطرح سؤالك هنا...';

  @override
  String get sendEmail => 'إرسال البريد الإلكتروني';

  @override
  String get faq => 'أسئلة شائعة';

  @override
  String get faqSavePdf => 'كيف أقوم بحفظ ملف PDF؟';

  @override
  String get faqSavePdfAnswer =>
      'بعد التقاط أو استيراد الصورة وتعديلها، اضغط على زر \"حفظ كـ PDF\".';

  @override
  String get faqEditPdf => 'هل يمكنني تعديل ملفات PDF الموجودة؟';

  @override
  String get faqEditPdfAnswer =>
      'حالياً، التطبيق يدعم إنشاء ملفات PDF جديدة من الصور فقط.';

  @override
  String get faqSaveLocation => 'أين يتم حفظ ملفات PDF؟';

  @override
  String get faqSaveLocationAnswer =>
      'يتم حفظ جميع الملفات في مجلد التطبيق الخاص على جهازك.';

  @override
  String get emailCopied => 'تم نسخ البريد الإلكتروني';

  @override
  String get couldNotOpenEmail => 'لا يمكن فتح تطبيق البريد الإلكتروني';

  @override
  String get fillAllFields => 'يرجى ملء جميع الحقول';

  @override
  String get weAreHereToHelp => 'نحن هنا لمساعدتك! تواصل معنا';
}
