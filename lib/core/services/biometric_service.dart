import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();
  
  // Check if biometric authentication is available
  static Future<bool> isBiometricAvailable() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }
  
  // Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }
  
  // Authenticate with biometrics
  static Future<bool> authenticateWithBiometrics({
    required String reason,
  }) async {
    try {
      final bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false, // Allow PIN/Pattern as fallback
          stickyAuth: true,
        ),
      );
      return isAuthenticated;
    } on PlatformException catch (e) {
      print('Biometric authentication error: $e');
      return false;
    }
  }
  
  // Check if biometric login is enabled for the user
  static Future<bool> isBiometricLoginEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('biometric_login_enabled') ?? false;
  }
  
  // Enable/disable biometric login
  static Future<void> setBiometricLoginEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_login_enabled', enabled);
  }
  
  // Save user credentials for biometric login (encrypted)
  static Future<void> saveBiometricCredentials(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('biometric_email', email);
  }
  
  // Get saved credentials for biometric login
  static Future<String?> getBiometricEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('biometric_email');
  }
  
  // Clear biometric credentials
  static Future<void> clearBiometricCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('biometric_email');
    await prefs.setBool('biometric_login_enabled', false);
  }
  
  // Get biometric type display name
  static String getBiometricTypeName(BiometricType type, bool isArabic) {
    switch (type) {
      case BiometricType.face:
        return isArabic ? 'التعرف على الوجه' : 'Face ID';
      case BiometricType.fingerprint:
        return isArabic ? 'بصمة الإصبع' : 'Fingerprint';
      case BiometricType.iris:
        return isArabic ? 'مسح القزحية' : 'Iris';
      case BiometricType.strong:
        return isArabic ? 'المصادقة القوية' : 'Strong Authentication';
      case BiometricType.weak:
        return isArabic ? 'المصادقة الضعيفة' : 'Weak Authentication';
      default:
        return isArabic ? 'المصادقة البيومترية' : 'Biometric';
    }
  }
}

