import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/locale_provider.dart';
import '../core/utils/app_localizations.dart';

class LanguageSelectorScreen extends StatelessWidget {
  const LanguageSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              l10n.chooseLanguage,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(spacing: 12, children: [
              FilledButton(
                onPressed: () {
                  context.read<LocaleProvider>().setEnglish();
                  Navigator.pushReplacementNamed(context, '/auth/sign-in');
                },
                child: const Text('English'),
              ),
              FilledButton(
                onPressed: () {
                  context.read<LocaleProvider>().setArabic();
                  Navigator.pushReplacementNamed(context, '/auth/sign-in');
                },
                child: const Text('العربية'),
              ),
            ]),
            const SizedBox(height: 24),
            Text(
              l10n.youCanChangeLater,
              style: const TextStyle(color: Colors.grey),
            ),
          ]),
        ),
      ),
    );
  }
}
