import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/luxury_components.dart';
import '../../../../l10n/app_localizations.dart';

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final String supportEmail = 'dimakhattab2017@gmail.com';
  
  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

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
                  Icons.support_agent,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            Center(
              child: Text(
                AppLocalizations.of(context)?.contactSupport ?? 'Contact Support',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtitle
            Center(
              child: Text(
                AppLocalizations.of(context)?.weAreHereToHelp ??
                  (isArabic ? 'نحن هنا لمساعدتك! تواصل معنا' : 'We\'re here to help! Get in touch'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Contact Methods
            _buildContactCard(
              context,
              icon: Icons.email_outlined,
              title: AppLocalizations.of(context)?.email ?? 'Email',
              subtitle: supportEmail,
              onTap: () => _launchEmail(),
              showCopy: true,
            ),
            const SizedBox(height: 16),
            
            _buildContactCard(
              context,
              icon: Icons.access_time_outlined,
              title: AppLocalizations.of(context)?.responseTime ?? 'Response Time',
              subtitle: AppLocalizations.of(context)?.within24Hours ?? 'Within 24 hours',
              onTap: null,
              showCopy: false,
            ),
            
            const SizedBox(height: 32),
            
            // Quick Email Form
            Text(
              AppLocalizations.of(context)?.sendQuickMessage ?? 'Send a Quick Message',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Subject Field
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.subject ?? 'Subject',
                hintText: AppLocalizations.of(context)?.enterSubject ?? 'Enter message subject',
                prefixIcon: const Icon(Icons.subject),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 16),
            
            // Message Field
            TextFormField(
              controller: _messageController,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.yourMessage ?? 'Your Message',
                hintText: AppLocalizations.of(context)?.describeIssue ?? 'Describe your issue or ask your question here...',
                prefixIcon: const Icon(Icons.message_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                alignLabelWithHint: true,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Send Button
            Center(
              child: LuxuryButton(
                text: AppLocalizations.of(context)?.sendEmail ?? 'Send Email',
                icon: Icons.send,
                onPressed: _sendEmail,
                width: double.infinity,
                height: 56,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // FAQ Section
            Text(
              AppLocalizations.of(context)?.faq ?? 'Frequently Asked Questions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildFAQItem(
              context,
              AppLocalizations.of(context)?.faqSavePdf ?? 'How do I save a PDF file?',
              AppLocalizations.of(context)?.faqSavePdfAnswer ?? 'After capturing or importing an image and editing it, tap the "Save as PDF" button.',
            ),
            
            _buildFAQItem(
              context,
              AppLocalizations.of(context)?.faqEditPdf ?? 'Can I edit existing PDF files?',
              AppLocalizations.of(context)?.faqEditPdfAnswer ?? 'Currently, the app only supports creating new PDF files from images.',
            ),
            
            _buildFAQItem(
              context,
              AppLocalizations.of(context)?.faqSaveLocation ?? 'Where are PDF files saved?',
              AppLocalizations.of(context)?.faqSaveLocationAnswer ?? 'All files are saved in the app\'s private folder on your device.',
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)?.contactSupport ?? 'Contact Support'),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
  
  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    required bool showCopy,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (showCopy)
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: subtitle));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)?.emailCopied ?? 'Email copied to clipboard',
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
    );
    
    if (!await launchUrl(emailUri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)?.couldNotOpenEmail ?? 'Could not open email app',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _sendEmail() async {
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();
    
    if (subject.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.fillAllFields ?? 'Please fill all fields',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      queryParameters: {
        'subject': '[Smart PDF Scanner] $subject',
        'body': message,
      },
    );
    
    if (!await launchUrl(emailUri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)?.couldNotOpenEmail ?? 'Could not open email app',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Clear form after successful launch
      _subjectController.clear();
      _messageController.clear();
    }
  }
}