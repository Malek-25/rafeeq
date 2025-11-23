import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/housing.dart';
import '../app_config.dart';

class HousingProvider extends ChangeNotifier {
  final List<Housing> _housings = [];
  
  List<Housing> get allHousings => List.unmodifiable(_housings);
  
  // Get housings for students (all active housings within 2km)
  List<Housing> get housingsForStudents => 
      _housings.where((housing) => housing.isActive && housing.distanceFromUni <= 2.0).toList();
  
  // Get housings for a specific provider
  List<Housing> getHousingsForProvider(String providerId) =>
      _housings.where((housing) => housing.providerId == providerId).toList();

  HousingProvider() {
    _loadDefaultHousings();
    _loadHousings();
  }

  // Load default housings (for demo purposes)
  void _loadDefaultHousings() {
    final defaultHousings = [
      Housing(
        id: 'default_1',
        title: 'Modern Studio near ASU',
        description: 'Modern studio apartment with all amenities, perfect for students.',
        pricePerMonth: 250.0,
        latitude: 32.0100,
        longitude: 35.8443,
        distanceFromUni: 0.8,
        providerId: 'default_housing_provider_1',
        providerName: 'ASU Housing',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        rating: 4,
      ),
      Housing(
        id: 'default_2',
        title: '2BR Apartment',
        description: 'Spacious 2-bedroom apartment with friendly roommates.',
        pricePerMonth: 380.0,
        latitude: 32.0110,
        longitude: 35.8451,
        distanceFromUni: 1.2,
        providerId: 'default_housing_provider_2',
        providerName: 'Student Housing Co.',
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        rating: 4,
      ),
      Housing(
        id: 'default_3',
        title: 'Cozy Room',
        description: 'Private room in a quiet neighborhood with kitchen access.',
        pricePerMonth: 180.0,
        latitude: 32.0250,
        longitude: 35.8600,
        distanceFromUni: 1.8,
        providerId: 'default_housing_provider_3',
        providerName: 'Campus Living',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        rating: 3,
      ),
    ];
    
    _housings.addAll(defaultHousings);
  }

  // Load housings from storage
  Future<void> _loadHousings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final housingsJson = prefs.getStringList('housings') ?? [];
      
      for (final housingJson in housingsJson) {
        final housingMap = json.decode(housingJson) as Map<String, dynamic>;
        final housing = Housing.fromMap(housingMap);
        
        // Avoid duplicates with default housings
        if (!_housings.any((h) => h.id == housing.id)) {
          _housings.add(housing);
        }
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading housings: $e');
    }
  }

  // Save housings to storage
  Future<void> _saveHousings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Only save non-default housings
      final customHousings = _housings.where((h) => !h.id.startsWith('default_')).toList();
      final housingsJson = customHousings.map((housing) => 
          json.encode(housing.toMap())).toList();
      
      await prefs.setStringList('housings', housingsJson);
    } catch (e) {
      debugPrint('Error saving housings: $e');
    }
  }

  // Add a new housing
  Future<bool> addHousing(Housing housing) async {
    try {
      // Calculate distance from university
      final distance = _calculateDistance(housing.latitude, housing.longitude);
      
      if (distance <= AppConfig.maxDistanceKm) {
        final housingWithDistance = housing.copyWith(distanceFromUni: distance);
        _housings.add(housingWithDistance);
        await _saveHousings();
        notifyListeners();
        return true;
      }
      return false; // Too far from university
    } catch (e) {
      debugPrint('Error adding housing: $e');
      return false;
    }
  }

  // Update a housing
  Future<bool> updateHousing(Housing updatedHousing) async {
    try {
      final index = _housings.indexWhere((h) => h.id == updatedHousing.id);
      if (index != -1) {
        _housings[index] = updatedHousing;
        await _saveHousings();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating housing: $e');
      return false;
    }
  }

  // Delete a housing
  Future<bool> deleteHousing(String housingId) async {
    try {
      _housings.removeWhere((h) => h.id == housingId);
      await _saveHousings();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting housing: $e');
      return false;
    }
  }

  // Toggle housing active status
  Future<bool> toggleHousingStatus(String housingId) async {
    try {
      final index = _housings.indexWhere((h) => h.id == housingId);
      if (index != -1) {
        _housings[index] = _housings[index].copyWith(
          isActive: !_housings[index].isActive,
        );
        await _saveHousings();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error toggling housing status: $e');
      return false;
    }
  }

  // Get housing by ID
  Housing? getHousingById(String housingId) {
    try {
      return _housings.firstWhere((h) => h.id == housingId);
    } catch (e) {
      return null;
    }
  }

  // Calculate distance from university
  double _calculateDistance(double lat, double lng) {
    // Simplified distance calculation using Haversine formula approximation
    const uniLat = AppConfig.uniLat;
    const uniLng = AppConfig.uniLng;
    
    final latDiff = (lat - uniLat).abs();
    final lngDiff = (lng - uniLng).abs();
    
    // Rough conversion to km (more accurate would use proper Haversine formula)
    return (latDiff + lngDiff) * 111;
  }
}