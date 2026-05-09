import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/app_localizations.dart';
import '../../core/providers/app_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/services/biometric_service.dart';
import '../../core/widgets/responsive_wrapper.dart';

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
          const SnackBar(content: Text('Invalid email or password.'), backgroundColor: Color(0xFFEB5757)),
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            // Language toggle
            TextButton(
              onPressed: () {
                final localeProvider = context.read<LocaleProvider>();
                if (localeProvider.locale.languageCode == 'ar') {
                  localeProvider.setEnglish();
                } else {
                  localeProvider.setArabic();
                }
              },
              child: Text(
                context.watch<LocaleProvider>().locale.languageCode == 'ar' ? 'EN' : 'عربي',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : ThemeProvider.textMedium,
                ),
              ),
            ),
          ],
        ),
        body: ResponsiveWrapper(
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo
                      Center(
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: ThemeProvider.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.school_rounded,
                                size: 36,
                                color: ThemeProvider.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        l10n.welcomeBack,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : ThemeProvider.textDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.isArabic ? 'سجل دخولك للمتابعة' : 'Sign in to your account',
                        style: TextStyle(
                          fontSize: 14,
                          color: ThemeProvider.textLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: l10n.email,
                          prefixIcon: const Icon(Icons.email_outlined, size: 20),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return l10n.isArabic ? 'مطلوب' : 'Required';
                          if (!v.contains('@')) return l10n.isArabic ? 'بريد غير صالح' : 'Invalid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Password
                      TextFormField(
                        controller: _passController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: l10n.password,
                          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              size: 20,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return l10n.isArabic ? 'مطلوب' : 'Required';
                          if (v.length < 6) return l10n.isArabic ? '6 أحرف على الأقل' : 'Min 6 characters';
                          return null;
                        },
                      ),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/auth/reset'),
                          child: Text(l10n.forgotPassword, style: const TextStyle(fontSize: 13)),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Sign In button
                      SizedBox(
                        height: 50,
                        child: FilledButton(
                          onPressed: _isLoading ? null : _handleSignIn,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Text(l10n.signIn, style: const TextStyle(fontSize: 16)),
                        ),
                      ),

                      // Biometric
                      if (_biometricAvailable && _biometricEnabled) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: _authenticateWithBiometrics,
                            icon: const Icon(Icons.fingerprint_rounded),
                            label: Text(l10n.isArabic ? 'الدخول بالبصمة' : 'Biometric Login'),
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Sign up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.dontHaveAccount,
                            style: TextStyle(color: ThemeProvider.textLight, fontSize: 14),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/auth/sign-up'),
                            child: Text(l10n.createAccount),
                          ),
                        ],
                      ),
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
