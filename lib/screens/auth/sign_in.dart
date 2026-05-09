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
  bool _isLoading = false;

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
      reason: l10n.isArabic ? 'تسجيل الدخول إلى رفيق' : 'Sign in to RAFEEQ',
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
              SnackBar(content: Text(l10n.isArabic ? 'فشل في تسجيل الدخول' : 'Login failed'), backgroundColor: Colors.red),
            );
          }
        }
      }
    }
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final appState = context.read<AppState>();
    final success = await appState.signIn(
      _emailController.text.trim(),
      _passController.text,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password.'), backgroundColor: Color(0xFFD50000)),
        );
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
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [const Color(0xFF0D47A1), const Color(0xFF121212)]
                  : [const Color(0xFF1565C0), const Color(0xFF0D47A1)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Top bar with language toggle
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: GestureDetector(
                          onTap: () {
                            final localeProvider = context.read<LocaleProvider>();
                            if (localeProvider.locale.languageCode == 'ar') {
                              localeProvider.setEnglish();
                            } else {
                              localeProvider.setArabic();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Text(
                              context.watch<LocaleProvider>().locale.languageCode == 'ar' ? 'EN' : 'عربي',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Logo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.school_rounded,
                            size: 48,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // App name
                    const Text(
                      'RAFEEQ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.isArabic ? 'رفيقك في الحياة الجامعية' : 'Your Student Life Companion',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Form Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.welcomeBack,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.isArabic ? 'سجل دخولك للمتابعة' : 'Sign in to continue',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? Colors.grey[400] : const Color(0xFF546E7A),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Email field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: l10n.email,
                                prefixIcon: Icon(Icons.email_outlined, color: isDark ? Colors.grey[400] : const Color(0xFF546E7A)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return l10n.isArabic ? 'أدخل بريدك الإلكتروني' : 'Enter your email';
                                if (!value.contains('@')) return l10n.isArabic ? 'بريد إلكتروني غير صالح' : 'Invalid email';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password field
                            TextFormField(
                              controller: _passController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: l10n.password,
                                prefixIcon: Icon(Icons.lock_outline_rounded, color: isDark ? Colors.grey[400] : const Color(0xFF546E7A)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                    color: isDark ? Colors.grey[400] : const Color(0xFF546E7A),
                                  ),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return l10n.isArabic ? 'أدخل كلمة المرور' : 'Enter your password';
                                if (value.length < 6) return l10n.isArabic ? '6 أحرف على الأقل' : 'At least 6 characters';
                                return null;
                              },
                            ),

                            // Forgot password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/auth/reset'),
                                child: Text(
                                  l10n.forgotPassword,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Sign In Button
                            SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleSignIn,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1565C0),
                                  foregroundColor: Colors.white,
                                  elevation: 4,
                                  shadowColor: const Color(0xFF1565C0).withOpacity(0.4),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        l10n.signIn,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),

                            // Biometric login
                            if (_biometricAvailable && _biometricEnabled) ...[
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: Divider(color: isDark ? Colors.grey[700] : Colors.grey[300])),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      l10n.isArabic ? 'أو' : 'OR',
                                      style: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[500], fontSize: 13),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: isDark ? Colors.grey[700] : Colors.grey[300])),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 50,
                                child: OutlinedButton.icon(
                                  onPressed: _authenticateWithBiometrics,
                                  icon: const Icon(Icons.fingerprint_rounded, size: 24),
                                  label: Text(
                                    l10n.isArabic ? 'الدخول بالبصمة' : 'Biometric Login',
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.dontHaveAccount,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/auth/sign-up'),
                          child: Text(
                            l10n.createAccount,
                            style: const TextStyle(
                              color: Color(0xFFFFAB00),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFFFFAB00),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
