import 'package:flutter/material.dart';
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  void setEnglish(){ _locale = const Locale('en'); notifyListeners(); }
  void setArabic(){ _locale = const Locale('ar'); notifyListeners(); }
}
