import 'package:flutter/material.dart';
import '../core/utils/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final isArabic = l10n.isArabic;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyPolicy),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'سياسة الخصوصية' : 'Privacy Policy',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic 
                        ? 'آخر تحديث: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
                        : 'Last updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Content sections
            ..._buildPolicySections(context, isArabic),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPolicySections(BuildContext context, bool isArabic) {
    final sections = isArabic ? _getArabicSections() : _getEnglishSections();
    
    return sections.map((section) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section['title']!,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          section['content']!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.6,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 24),
      ],
    )).toList();
  }

  List<Map<String, String>> _getArabicSections() {
    return [
      {
        'title': '1. المقدمة',
        'content': 'مرحباً بك في تطبيق رفيق. نحن نحترم خصوصيتك ونلتزم بحماية معلوماتك الشخصية. توضح هذه السياسة كيفية جمع واستخدام وحماية المعلومات التي تقدمها لنا عند استخدام تطبيقنا.',
      },
      {
        'title': '2. المعلومات التي نجمعها',
        'content': 'نقوم بجمع المعلومات التالية:\n• معلومات الحساب: الاسم، البريد الإلكتروني، رقم الهاتف\n• معلومات الاستخدام: كيفية تفاعلك مع التطبيق\n• معلومات الموقع: لعرض الخدمات القريبة منك\n• معلومات الجهاز: نوع الجهاز ونظام التشغيل',
      },
      {
        'title': '3. كيف نستخدم معلوماتك',
        'content': 'نستخدم معلوماتك لـ:\n• تقديم وتحسين خدماتنا\n• التواصل معك بشأن حسابك والخدمات\n• معالجة المعاملات والطلبات\n• ضمان أمان التطبيق ومنع الاحتيال\n• تخصيص تجربتك في التطبيق',
      },
      {
        'title': '4. مشاركة المعلومات',
        'content': 'لا نبيع أو نؤجر معلوماتك الشخصية لأطراف ثالثة. قد نشارك معلوماتك في الحالات التالية:\n• مع مقدمي الخدمات المعتمدين لتنفيذ الطلبات\n• عند الضرورة القانونية أو لحماية حقوقنا\n• في حالة بيع أو دمج الشركة (بعد إشعارك)',
      },
      {
        'title': '5. أمان البيانات',
        'content': 'نتخذ تدابير أمنية مناسبة لحماية معلوماتك من الوصول غير المصرح به أو التغيير أو الكشف أو التدمير. نستخدم التشفير وبروتوكولات الأمان المعيارية في الصناعة.',
      },
      {
        'title': '6. حقوقك',
        'content': 'لديك الحق في:\n• الوصول إلى معلوماتك الشخصية وتحديثها\n• طلب حذف حسابك ومعلوماتك\n• الاعتراض على معالجة معلوماتك\n• نقل بياناتك إلى خدمة أخرى\n• سحب موافقتك في أي وقت',
      },
      {
        'title': '7. الاتصال بنا',
        'content': 'إذا كان لديك أي أسئلة حول سياسة الخصوصية هذه، يمكنك التواصل معنا عبر:\nالبريد الإلكتروني: privacy@rafeeq.app\nالهاتف: +962-6-1234567\nالعنوان: الجامعة الأردنية، عمان، الأردن',
      },
    ];
  }

  List<Map<String, String>> _getEnglishSections() {
    return [
      {
        'title': '1. Introduction',
        'content': 'Welcome to RAFEEQ app. We respect your privacy and are committed to protecting your personal information. This policy explains how we collect, use, and protect the information you provide when using our application.',
      },
      {
        'title': '2. Information We Collect',
        'content': 'We collect the following information:\n• Account information: name, email, phone number\n• Usage information: how you interact with the app\n• Location information: to show nearby services\n• Device information: device type and operating system',
      },
      {
        'title': '3. How We Use Your Information',
        'content': 'We use your information to:\n• Provide and improve our services\n• Communicate with you about your account and services\n• Process transactions and orders\n• Ensure app security and prevent fraud\n• Personalize your app experience',
      },
      {
        'title': '4. Information Sharing',
        'content': 'We do not sell or rent your personal information to third parties. We may share your information in the following cases:\n• With authorized service providers to fulfill orders\n• When legally required or to protect our rights\n• In case of company sale or merger (after notifying you)',
      },
      {
        'title': '5. Data Security',
        'content': 'We take appropriate security measures to protect your information from unauthorized access, alteration, disclosure, or destruction. We use encryption and industry-standard security protocols.',
      },
      {
        'title': '6. Your Rights',
        'content': 'You have the right to:\n• Access and update your personal information\n• Request deletion of your account and information\n• Object to processing of your information\n• Transfer your data to another service\n• Withdraw your consent at any time',
      },
      {
        'title': '7. Contact Us',
        'content': 'If you have any questions about this privacy policy, you can contact us via:\nEmail: privacy@rafeeq.app\nPhone: +962-6-1234567\nAddress: Jordan University, Amman, Jordan',
      },
    ];
  }
}

