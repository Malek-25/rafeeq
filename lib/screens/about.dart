import 'package:flutter/material.dart';
import '../core/utils/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final isArabic = l10n.isArabic;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.about),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo and Name
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // University Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 116,
                        height: 116,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_rounded,
                                size: 40,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'ASU',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'رفيق - RAFEEQ',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic 
                        ? 'رفيقك في الحياة الجامعية'
                        : 'Your Student Life Companion',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // App Description
            _buildInfoCard(
              context,
              isArabic ? 'حول التطبيق' : 'About the App',
              isArabic 
                  ? 'رفيق هو تطبيق مصمم خصيصاً لخدمة الطلاب الجامعيين، حيث يوفر منصة شاملة تربط الطلاب بمقدمي الخدمات لتلبية احتياجاتهم اليومية من سكن وخدمات تنظيف وغسيل، بالإضافة إلى سوق إلكتروني لتبادل المستلزمات الطلابية.'
                  : 'RAFEEQ is an application designed specifically for university students, providing a comprehensive platform that connects students with service providers to meet their daily needs for housing, cleaning and laundry services, in addition to an electronic marketplace for exchanging student supplies.',
              Icons.info_outline,
            ),
            
            // Features
            _buildInfoCard(
              context,
              isArabic ? 'المميزات الرئيسية' : 'Key Features',
              isArabic 
                  ? '• البحث عن السكن الطلابي المناسب\n• خدمات الغسيل والتنظيف\n• سوق لبيع وشراء المستلزمات\n• نظام تقييم موثوق\n• دعم اللغتين العربية والإنجليزية\n• واجهة سهلة الاستخدام'
                  : '• Search for suitable student housing\n• Laundry and cleaning services\n• Marketplace for buying and selling supplies\n• Reliable rating system\n• Arabic and English language support\n• User-friendly interface',
              Icons.star_outline,
            ),
            
            // Version Info
            _buildInfoCard(
              context,
              isArabic ? 'معلومات الإصدار' : 'Version Information',
              isArabic 
                  ? 'الإصدار: 1.0.0\nتاريخ الإصدار: ${DateTime.now().year}\nمطور بواسطة: فريق رفيق'
                  : 'Version: 1.0.0\nRelease Date: ${DateTime.now().year}\nDeveloped by: RAFEEQ Team',
              Icons.code_outlined,
            ),
            
            // Contact Info
            _buildInfoCard(
              context,
              isArabic ? 'تواصل معنا' : 'Contact Us',
              isArabic 
                  ? 'البريد الإلكتروني: info@rafeeq.app\nالهاتف: +962-6-1234567\nالموقع: www.rafeeq.app\nالعنوان: الجامعة الأردنية، عمان، الأردن'
                  : 'Email: info@rafeeq.app\nPhone: +962-6-1234567\nWebsite: www.rafeeq.app\nAddress: Jordan University, Amman, Jordan',
              Icons.contact_mail_outlined,
            ),
            
            const SizedBox(height: 20),
            
            // Copyright
            Text(
              isArabic 
                  ? '© ${DateTime.now().year} رفيق. جميع الحقوق محفوظة.'
                  : '© ${DateTime.now().year} RAFEEQ. All rights reserved.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String content, IconData icon) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? Colors.grey[800]?.withOpacity(0.3)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey[600]!.withOpacity(0.3)
              : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.grey[300]
                  : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
