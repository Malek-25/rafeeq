import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme_provider.dart';
import '../core/providers/locale_provider.dart';
import '../core/providers/app_provider.dart';
import '../core/utils/app_localizations.dart';
import '../core/services/biometric_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricEnabled = false;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricStatus();
  }

  Future<void> _checkBiometricStatus() async {
    final available = await BiometricService.isBiometricAvailable();
    final enabled = await BiometricService.isBiometricLoginEnabled();
    
    if (mounted) {
      setState(() {
        _biometricAvailable = available;
        _biometricEnabled = enabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final locale = context.watch<LocaleProvider>();
    final app = context.watch<AppState>();
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final isArabic = l10n.isArabic;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ListTile(title: Text(l10n.general, style: const TextStyle(fontWeight: FontWeight.bold))),
          ListTile(
            title: Text(l10n.language), 
            subtitle: Text(locale.locale.languageCode == 'ar' ? 'العربية' : 'English'),
            trailing: DropdownButton<String>(
              value: locale.locale.languageCode,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
              ],
              onChanged: (value) {
                if (value == 'en') {
                  locale.setEnglish();
                } else if (value == 'ar') {
                  locale.setArabic();
                }
              },
            ),
          ),
          SwitchListTile(
            title: Text(l10n.darkMode), 
            value: theme.mode==ThemeMode.dark, 
            onChanged: (v)=>theme.setMode(v?ThemeMode.dark:ThemeMode.light),
          ),
          const Divider(),

          ListTile(title: Text(l10n.payments, style: const TextStyle(fontWeight: FontWeight.bold))),
          ListTile(
            leading: const Icon(Icons.credit_card), 
            title: Text(l10n.addCard), 
            onTap: () async {
              final holder = TextEditingController(); 
              final last4 = TextEditingController(); 
              String brand = 'VISA';
              await showDialog(context: context, builder: (_)=>AlertDialog(
                title: Text(l10n.addCard),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(controller: holder, decoration: InputDecoration(labelText: l10n.cardHolder)),
                  TextField(controller: last4, decoration: InputDecoration(labelText: l10n.last4Digits)),
                  DropdownButton<String>(value: brand, items: const [
                    DropdownMenuItem(value: 'VISA', child: Text('VISA')),
                    DropdownMenuItem(value: 'MC', child: Text('Mastercard')),
                  ], onChanged: (v){ brand = v ?? 'VISA'; }),
                ]),
                actions: [
                  TextButton(onPressed: ()=>Navigator.pop(context), child: Text(l10n.cancel)),
                  FilledButton(
                    onPressed: (){ 
                      if(last4.text.trim().length==4){ 
                        context.read<AppState>().addCard(CardItem(
                          id: DateTime.now().toString(), 
                          holder: holder.text.trim(), 
                          last4: last4.text.trim(), 
                          brand: brand,
                        )); 
                        Navigator.pop(context);
                      }
                    }, 
                    child: Text(l10n.save),
                  ),
                ],
              ));
            },
          ),
          if(app.cards.isNotEmpty) ...[
            const SizedBox(height: 8), 
            Text(l10n.savedCards),
            ...app.cards.map((c)=>ListTile(title: Text('${c.brand} •••• ${c.last4}'), subtitle: Text(c.holder))),
          ],
          const Divider(),

          ListTile(title: Text(l10n.notifications, style: const TextStyle(fontWeight: FontWeight.bold))),
          SwitchListTile(title: Text(l10n.orderUpdates), value: true, onChanged: (_)=>{}),
          SwitchListTile(title: Text(l10n.messages), value: true, onChanged: (_)=>{}),
          const Divider(),

          ListTile(title: Text(isArabic ? 'الأمان' : 'Security', style: const TextStyle(fontWeight: FontWeight.bold))),
          SwitchListTile(
            title: Text(isArabic ? 'تسجيل الدخول بالبصمة' : 'Biometric Login'),
            subtitle: Text(
              _biometricAvailable 
                  ? (isArabic ? 'استخدم البصمة أو النمط لتسجيل الدخول' : 'Use fingerprint or pattern to login')
                  : (isArabic ? 'البصمة غير متاحة على هذا الجهاز' : 'Biometric not available on this device')
            ),
            value: _biometricEnabled && _biometricAvailable,
            onChanged: _biometricAvailable ? (value) async {
              if (value) {
                // Enable biometric login
                final authenticated = await BiometricService.authenticateWithBiometrics(
                  reason: isArabic 
                      ? 'تأكيد الهوية لتفعيل تسجيل الدخول بالبصمة'
                      : 'Verify your identity to enable biometric login',
                );
                
                if (authenticated) {
                  await BiometricService.setBiometricLoginEnabled(true);
                  await BiometricService.saveBiometricCredentials(app.userEmail ?? '');
                  
                  setState(() {
                    _biometricEnabled = true;
                  });
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isArabic ? 'تم تفعيل تسجيل الدخول بالبصمة' : 'Biometric login enabled'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isArabic ? 'فشل في التحقق من الهوية' : 'Authentication failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } else {
                // Disable biometric login
                await BiometricService.setBiometricLoginEnabled(false);
                setState(() {
                  _biometricEnabled = false;
                });
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isArabic ? 'تم إلغاء تسجيل الدخول بالبصمة' : 'Biometric login disabled'),
                    ),
                  );
                }
              }
            } : null,
          ),
          const Divider(),

          ListTile(title: Text(l10n.legal, style: const TextStyle(fontWeight: FontWeight.bold))),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined), 
            title: Text(l10n.privacyPolicy),
            onTap: () => Navigator.pushNamed(context, '/privacy-policy'),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined), 
            title: Text(l10n.termsOfService),
            onTap: () => Navigator.pushNamed(context, '/terms-of-service'),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.about), 
            subtitle: Text('${l10n.appName} • ASU'),
            onTap: () => Navigator.pushNamed(context, '/about'),
          ),
          const Divider(),
          
          // Account Section
          ListTile(title: Text('Account', style: const TextStyle(fontWeight: FontWeight.bold))),
          if (app.userEmail != null)
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: Text('Email'),
              subtitle: Text(app.userEmail!),
            ),
          if (app.userName != null)
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text('Name'),
              subtitle: Text(app.userName!),
            ),
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: Text('Role'),
            subtitle: Text(app.role == UserRole.provider ? l10n.provider : l10n.student),
          ),
          const Divider(),
          
          // Logout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FilledButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.signOut),
                    content: Text(isArabic ? 'هل أنت متأكد من تسجيل الخروج؟' : 'Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(l10n.cancel),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(l10n.signOut),
                      ),
                    ],
                  ),
                );
                
                if (confirm == true && context.mounted) {
                  await app.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/auth/sign-in',
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout),
              label: Text(l10n.signOut),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
