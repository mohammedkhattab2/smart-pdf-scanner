import 'package:flutter/material.dart';
import '../../../../core/widgets/luxury_components.dart';
import '../../../../l10n/app_localizations.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.description_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            Center(
              child: Text(
                AppLocalizations.of(context)?.termsOfService ?? 'Terms of Service',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Last updated
            Center(
              child: Text(
                '${isArabic ? 'آخر تحديث' : 'Last Updated'}: March 8, 2026',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Terms content
            _buildSection(
              context,
              isArabic ? '1. قبول الشروط' : '1. Acceptance of Terms',
              isArabic
                  ? 'باستخدامك لتطبيق Smart PDF Scanner، فإنك توافق على الالتزام بهذه الشروط. إذا كنت لا توافق على هذه الشروط، يُرجى عدم استخدام التطبيق.'
                  : 'By using Smart PDF Scanner, you agree to be bound by these Terms. If you do not agree to these Terms, please do not use the app.',
            ),
            
            _buildSection(
              context,
              isArabic ? '2. وصف الخدمة' : '2. Service Description',
              isArabic
                  ? 'Smart PDF Scanner هو تطبيق لمسح المستندات وتحويلها إلى ملفات PDF. يوفر التطبيق ميزات مثل التقاط الصور، قص الصور، تحسين جودة الصور، وإنشاء ملفات PDF.'
                  : 'Smart PDF Scanner is a document scanning app that converts documents to PDF files. The app provides features such as image capture, image cropping, image enhancement, and PDF creation.',
            ),
            
            _buildSection(
              context,
              isArabic ? '3. استخدام التطبيق' : '3. Use of the App',
              isArabic
                  ? '''يُسمح لك باستخدام التطبيق للأغراض الشخصية والتجارية المشروعة. يُحظر عليك:
• استخدام التطبيق بطريقة غير قانونية أو لأغراض غير مشروعة
• محاولة الوصول غير المصرح به إلى أي جزء من التطبيق
• نسخ أو تعديل أو توزيع التطبيق دون إذن'''
                  : '''You are permitted to use the app for personal and legitimate commercial purposes. You are prohibited from:
• Using the app in any unlawful manner or for illegal purposes
• Attempting unauthorized access to any part of the app
• Copying, modifying, or distributing the app without permission''',
            ),
            
            _buildSection(
              context,
              isArabic ? '4. الخصوصية' : '4. Privacy',
              isArabic
                  ? 'نحن نحترم خصوصيتك. جميع الصور والمستندات التي تقوم بمعالجتها باستخدام التطبيق تبقى على جهازك المحلي. لا نقوم بجمع أو تحميل أو مشاركة أي من مستنداتك الشخصية.'
                  : 'We respect your privacy. All images and documents you process using the app remain on your local device. We do not collect, upload, or share any of your personal documents.',
            ),
            
            _buildSection(
              context,
              isArabic ? '5. الأذونات' : '5. Permissions',
              isArabic
                  ? '''يتطلب التطبيق الأذونات التالية:
• الكاميرا: لالتقاط صور المستندات
• معرض الصور: لاستيراد الصور الموجودة
• التخزين: لحفظ ملفات PDF المُنشأة'''
                  : '''The app requires the following permissions:
• Camera: To capture document photos
• Photo Gallery: To import existing images
• Storage: To save generated PDF files''',
            ),
            
            _buildSection(
              context,
              isArabic ? '6. إخلاء المسؤولية' : '6. Disclaimer',
              isArabic
                  ? 'يتم توفير التطبيق "كما هو" دون أي ضمانات من أي نوع. نحن لا نضمن أن التطبيق سيكون خاليًا من الأخطاء أو متاحًا دون انقطاع.'
                  : 'The app is provided "as is" without warranties of any kind. We do not guarantee that the app will be error-free or available without interruption.',
            ),
            
            _buildSection(
              context,
              isArabic ? '7. تحديد المسؤولية' : '7. Limitation of Liability',
              isArabic
                  ? 'لن نكون مسؤولين عن أي أضرار مباشرة أو غير مباشرة أو عرضية أو خاصة أو تبعية ناتجة عن استخدام أو عدم القدرة على استخدام التطبيق.'
                  : 'We shall not be liable for any direct, indirect, incidental, special, or consequential damages arising from the use or inability to use the app.',
            ),
            
            _buildSection(
              context,
              isArabic ? '8. التغييرات على الشروط' : '8. Changes to Terms',
              isArabic
                  ? 'نحتفظ بالحق في تعديل هذه الشروط في أي وقت. سيتم إشعارك بأي تغييرات من خلال التطبيق.'
                  : 'We reserve the right to modify these Terms at any time. You will be notified of any changes through the app.',
            ),
            
            _buildSection(
              context,
              isArabic ? '9. الاتصال بنا' : '9. Contact Us',
              isArabic
                  ? 'إذا كان لديك أي أسئلة حول هذه الشروط، يُرجى الاتصال بنا على:\nsupport@smartpdfscanner.com'
                  : 'If you have any questions about these Terms, please contact us at:\nsupport@smartpdfscanner.com',
            ),
            
            const SizedBox(height: 32),
            
            // Agree button
            Center(
              child: LuxuryButton(
                text: isArabic ? 'موافق' : 'I Agree',
                icon: Icons.check_circle_outline,
                onPressed: () => Navigator.of(context).pop(),
                width: 200,
                height: 48,
              ),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)?.termsOfService ?? 'Terms of Service'),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
  
  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.6,
          ),
        ),
      ],
    );
  }
}