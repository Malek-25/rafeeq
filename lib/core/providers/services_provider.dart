import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/service.dart';

class ServicesProvider extends ChangeNotifier {
  final List<Service> _services = [];
  
  List<Service> get allServices => List.unmodifiable(_services);
  
  // Get services for students (all active services, excluding default listings)
  List<Service> get servicesForStudents => 
      _services.where((service) => 
        service.isActive && 
        !service.id.startsWith('default_') &&
        !service.providerId.startsWith('default_')
      ).toList();
  
  // Get services for a specific provider
  List<Service> getServicesForProvider(String providerId) =>
      _services.where((service) => service.providerId == providerId).toList();
  
  // Get services by category
  List<Service> getServicesByCategory(String category) =>
      _services.where((service) => 
          service.category == category && service.isActive).toList();

  ServicesProvider() {
    _loadServices();
  }

  // Load services from storage
  Future<void> _loadServices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final servicesJson = prefs.getStringList('services') ?? [];
      
      for (final serviceJson in servicesJson) {
        final serviceMap = json.decode(serviceJson) as Map<String, dynamic>;
        final service = Service.fromMap(serviceMap);
        
        // Only load non-default services (exclude default listings)
        if (!service.id.startsWith('default_') && 
            !service.providerId.startsWith('default_') &&
            !_services.any((s) => s.id == service.id)) {
          _services.add(service);
        }
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading services: $e');
    }
  }

  // Save services to storage
  Future<void> _saveServices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Only save non-default services
      final customServices = _services.where((s) => !s.id.startsWith('default_')).toList();
      final servicesJson = customServices.map((service) => 
          json.encode(service.toMap())).toList();
      
      await prefs.setStringList('services', servicesJson);
    } catch (e) {
      debugPrint('Error saving services: $e');
    }
  }

  // Add a new service
  Future<bool> addService(Service service) async {
    try {
      _services.add(service);
      await _saveServices();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding service: $e');
      return false;
    }
  }

  // Update a service
  Future<bool> updateService(Service updatedService) async {
    try {
      final index = _services.indexWhere((s) => s.id == updatedService.id);
      if (index != -1) {
        _services[index] = updatedService;
        await _saveServices();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating service: $e');
      return false;
    }
  }

  // Delete a service
  Future<bool> deleteService(String serviceId) async {
    try {
      _services.removeWhere((s) => s.id == serviceId);
      await _saveServices();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting service: $e');
      return false;
    }
  }

  // Toggle service active status
  Future<bool> toggleServiceStatus(String serviceId) async {
    try {
      final index = _services.indexWhere((s) => s.id == serviceId);
      if (index != -1) {
        _services[index] = _services[index].copyWith(
          isActive: !_services[index].isActive,
        );
        await _saveServices();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error toggling service status: $e');
      return false;
    }
  }

  // Get service by ID
  Service? getServiceById(String serviceId) {
    try {
      return _services.firstWhere((s) => s.id == serviceId);
    } catch (e) {
      return null;
    }
  }
}

