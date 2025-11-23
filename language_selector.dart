import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/locale_provider.dart';

class LanguageSelectorScreen extends StatelessWidget {
  const LanguageSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Choose language / اختر اللغة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(spacing: 12, children: [
              FilledButton(onPressed: (){ context.read<LocaleProvider>().setEnglish(); Navigator.pushReplacementNamed(context, '/auth/sign-in'); }, child: const Text('English')),
              FilledButton(onPressed: (){ context.read<LocaleProvider>().setArabic(); Navigator.pushReplacementNamed(context, '/auth/sign-in'); }, child: const Text('العربية')),
            ]),
            const SizedBox(height: 24),
            const Text('You can change later from Settings', style: TextStyle(color: Colors.grey)),
          ]),
        ),
      ),
    );
  }
}
