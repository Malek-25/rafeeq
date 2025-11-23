import 'package:flutter/material.dart';
import '../core/utils/app_localizations.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final isArabic = l10n.isArabic;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.termsOfService),
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
                    isArabic ? 'شروط الخدمة' : 'Terms of Service',
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
            ..._buildTermsSections(context, isArabic),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTermsSections(BuildContext context, bool isArabic) {
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
        'title': '1. قبول الشروط',
        'content': 'باستخدامك لتطبيق رفيق، فإنك توافق على الالتزام بهذه الشروط والأحكام. إذا كنت لا توافق على أي من هذه الشروط، يرجى عدم استخدام التطبيق.',
      },
      {
        'title': '2. وصف الخدمة',
        'content': 'رفيق هو تطبيق يربط الطلاب الجامعيين بمقدمي الخدمات لتوفير:\n• خدمات السكن الطلابي\n• خدمات الغسيل والتنظيف\n• سوق لبيع وشراء المستلزمات الطلابية\n• خدمات أخرى متعلقة بالحياة الجامعية',
      },
      {
        'title': '3. التسجيل والحساب',
        'content': 'يجب عليك:\n• تقديم معلومات صحيحة ودقيقة عند التسجيل\n• الحفاظ على سرية كلمة المرور\n• إشعارنا فوراً بأي استخدام غير مصرح به لحسابك\n• تحديث معلوماتك عند الضرورة',
      },
      {
        'title': '4. قواعد الاستخدام',
        'content': 'يُمنع عليك:\n• استخدام التطبيق لأغراض غير قانونية\n• نشر محتوى مسيء أو غير لائق\n• انتحال شخصية الآخرين\n• التلاعب في النظام أو محاولة اختراقه\n• إزعاج المستخدمين الآخرين',
      },
      {
        'title': '5. المدفوعات والرسوم',
        'content': 'جميع المعاملات المالية تتم بين المستخدمين مباشرة. التطبيق يسهل عملية التواصل فقط. نحن غير مسؤولين عن:\n• جودة الخدمات المقدمة\n• النزاعات المالية بين المستخدمين\n• عمليات الاحتيال (رغم جهودنا لمنعها)',
      },
      {
        'title': '6. مسؤوليات مقدمي الخدمات',
        'content': 'مقدمو الخدمات ملزمون بـ:\n• تقديم معلومات صحيحة عن خدماتهم\n• الالتزام بالمواعيد المتفق عليها\n• تقديم خدمات بجودة مقبولة\n• احترام خصوصية العملاء\n• الامتثال للقوانين المحلية',
      },
      {
        'title': '7. إخلاء المسؤولية',
        'content': 'التطبيق يعمل كوسيط فقط. نحن غير مسؤولين عن:\n• جودة أو سلامة الخدمات المقدمة\n• الأضرار الناتجة عن استخدام الخدمات\n• فقدان البيانات أو انقطاع الخدمة\n• أي خسائر مالية أو معنوية',
      },
      {
        'title': '8. إنهاء الخدمة',
        'content': 'يحق لنا إنهاء أو تعليق حسابك في حالة:\n• انتهاك هذه الشروط\n• سوء استخدام التطبيق\n• تلقي شكاوى متكررة ضدك\n• لأسباب أمنية أو قانونية',
      },
      {
        'title': '9. تعديل الشروط',
        'content': 'نحتفظ بالحق في تعديل هذه الشروط في أي وقت. سيتم إشعارك بأي تغييرات مهمة عبر التطبيق أو البريد الإلكتروني.',
      },
      {
        'title': '10. القانون المطبق',
        'content': 'تخضع هذه الشروط لقوانين المملكة الأردنية الهاشمية. أي نزاع ينشأ عن استخدام التطبيق سيتم حله وفقاً للقوانين الأردنية.',
      },
    ];
  }

  List<Map<String, String>> _getEnglishSections() {
    return [
      {
        'title': '1. Acceptance of Terms',
        'content': 'By using the RAFEEQ app, you agree to comply with these terms and conditions. If you do not agree to any of these terms, please do not use the application.',
      },
      {
        'title': '2. Service Description',
        'content': 'RAFEEQ is an application that connects university students with service providers to offer:\n• Student housing services\n• Laundry and cleaning services\n• Marketplace for buying and selling student supplies\n• Other university life-related services',
      },
      {
        'title': '3. Registration and Account',
        'content': 'You must:\n• Provide accurate and truthful information when registering\n• Maintain the confidentiality of your password\n• Notify us immediately of any unauthorized use of your account\n• Update your information when necessary',
      },
      {
        'title': '4. Usage Rules',
        'content': 'You are prohibited from:\n• Using the app for illegal purposes\n• Posting offensive or inappropriate content\n• Impersonating others\n• Manipulating the system or attempting to hack it\n• Harassing other users',
      },
      {
        'title': '5. Payments and Fees',
        'content': 'All financial transactions occur directly between users. The app only facilitates communication. We are not responsible for:\n• Quality of services provided\n• Financial disputes between users\n• Fraud (despite our efforts to prevent it)',
      },
      {
        'title': '6. Service Provider Responsibilities',
        'content': 'Service providers are required to:\n• Provide accurate information about their services\n• Adhere to agreed-upon schedules\n• Provide services of acceptable quality\n• Respect customer privacy\n• Comply with local laws',
      },
      {
        'title': '7. Disclaimer',
        'content': 'The app acts as an intermediary only. We are not responsible for:\n• Quality or safety of services provided\n• Damages resulting from service use\n• Data loss or service interruption\n• Any financial or moral losses',
      },
      {
        'title': '8. Service Termination',
        'content': 'We reserve the right to terminate or suspend your account in case of:\n• Violation of these terms\n• App misuse\n• Receiving repeated complaints against you\n• Security or legal reasons',
      },
      {
        'title': '9. Terms Modification',
        'content': 'We reserve the right to modify these terms at any time. You will be notified of any important changes via the app or email.',
      },
      {
        'title': '10. Applicable Law',
        'content': 'These terms are subject to the laws of the Hashemite Kingdom of Jordan. Any dispute arising from app use will be resolved according to Jordanian law.',
      },
    ];
  }
}

