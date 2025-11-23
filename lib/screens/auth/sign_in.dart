import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/app_localizations.dart';
import '../../core/providers/app_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/services/biometric_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePassword = true;
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;

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

  Future<void> _authenticateWithBiometrics() async {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    
    final authenticated = await BiometricService.authenticateWithBiometrics(
      reason: l10n.isArabic 
          ? 'تسجيل الدخول إلى رفيق'
          : 'Sign in to RAFEEQ',
    );
    
    if (authenticated) {
      final email = await BiometricService.getBiometricEmail();
      if (email != null && email.isNotEmpty) {
        final appState = context.read<AppState>();
        final success = await appState.signIn(email, 'biometric_login');
        
        if (mounted) {
          if (success) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.isArabic ? 'فشل في تسجيل الدخول' : 'Login failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));

    return PopScope(
      canPop: false, // Prevent back button navigation - user must sign in
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false, // Remove back button completely
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            // Language toggle button
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    final localeProvider = context.read<LocaleProvider>();
                    if (localeProvider.locale.languageCode == 'ar') {
                      localeProvider.setEnglish();
                    } else {
                      localeProvider.setArabic();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.white.withOpacity(0.6)
                            : Theme.of(context).primaryColor.withOpacity(0.6),
                        width: 1.5,
                      ),
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.white.withOpacity(0.15)
                          : Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                    child: Text(
                      context.watch<LocaleProvider>().locale.languageCode == 'ar' ? 'EN' : 'AR',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: Theme.of(context).brightness == Brightness.dark 
                  ? [
                      Colors.grey[900]!.withOpacity(0.8),
                      Colors.grey[900]!,
                      Colors.grey[900]!,
                    ]
                  : [
                      ThemeProvider.asuNavy.withOpacity(0.1),
                      ThemeProvider.asuNavy.withOpacity(0.05),
                      ThemeProvider.asuNavy.withOpacity(0.05),
                    ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      // --- START: MODIFIED LOGO SECTION ---
                      // We use a SizedBox to constrain the size of the logo precisely.
                      SizedBox(
                        width: 120, // Reduced from 200
                        height: 120, // Reduced from 200
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain, // Use contain to ensure the whole logo is visible
                          errorBuilder: (context, error, stackTrace) {
                            // Return an icon if the logo fails to load, which helps in debugging.
                            return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                          },
                        ),
                      ),
                      // --- END: MODIFIED LOGO SECTION ---
                      const SizedBox(height: 8),
                      Text(
                        l10n.welcomeBack,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: l10n.email,
                          prefixIcon: const Icon(Icons.email_rounded),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.0), // Transparent background
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.5,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: l10n.password,
                          prefixIcon: const Icon(Icons.lock_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.0), // Transparent background
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.5,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/auth/reset'),
                          child: Text(l10n.forgotPassword),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Material(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(0.4),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              final appState = context.read<AppState>();
                              final success = await appState.signIn(
                                _emailController.text.trim(),
                                _passController.text,
                              );

                              if (context.mounted) {
                                if (success) {
                                  Navigator.pushReplacementNamed(context, '/home');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Invalid email or password.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              l10n.signIn,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Biometric login button
                      if (_biometricAvailable && _biometricEnabled) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: Divider(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.grey[300],
                            )),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                l10n.isArabic ? 'أو' : 'OR',
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark 
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.grey[300],
                            )),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: _authenticateWithBiometrics,
                            icon: Icon(
                              Icons.fingerprint_rounded,
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            label: Text(
                              l10n.isArabic ? 'تسجيل الدخول بالبصمة' : 'Sign in with Biometric',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.white.withOpacity(0.7)
                                    : Theme.of(context).primaryColor,
                                width: 1.5,
                              ),
                              backgroundColor: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.dontHaveAccount,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/auth/sign-up'),
                            child: Text(l10n.createAccount),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
