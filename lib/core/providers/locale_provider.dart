import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  // Load saved language preference
  Future<void> loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language') ?? 'en';
      _locale = Locale(languageCode);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading locale: $e');
      _locale = const Locale('en'); // Default to English
    }
  }

  // Save and set English
  Future<void> setEnglish() async {
    _locale = const Locale('en');
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', 'en');
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  // Save and set Arabic
  Future<void> setArabic() async {
    _locale = const Locale('ar');
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', 'ar');
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }
}
