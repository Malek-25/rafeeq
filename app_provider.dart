import 'package:flutter/material.dart';

enum UserRole { student, provider }

class CardItem {
  final String id;
  final String holder;
  final String last4;
  final String brand;
  CardItem({required this.id, required this.holder, required this.last4, required this.brand});
}

class AppState extends ChangeNotifier {
  UserRole role = UserRole.student;
  double wallet = 25.0;
  String? profilePhotoPath;
  final List<CardItem> _cards = [];

  List<CardItem> get cards => List.unmodifiable(_cards);

  void setRole(UserRole r){ role = r; notifyListeners(); }
  void setProfilePhoto(String path){ profilePhotoPath = path; notifyListeners(); }
  void topUp(double v){ wallet += v; notifyListeners(); }
  bool deduct(double v){ if(wallet >= v){ wallet -= v; notifyListeners(); return true; } return false; }
  void addCard(CardItem c){ _cards.add(c); notifyListeners(); }
}
