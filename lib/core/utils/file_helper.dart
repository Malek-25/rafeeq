import 'package:flutter/foundation.dart' show kIsWeb;

/// Helper class to handle file operations across platforms
class FileHelper {
  /// Get a file object from a path (works on mobile/desktop, not web)
  /// Returns null on web platform
  static dynamic getFile(String path) {
    if (kIsWeb) {
      return null; // File not available on web
    }
    // On non-web platforms, we'll handle this in the calling code
    // by importing dart:io directly where needed
    return null;
  }

  /// Check if file operations are supported on current platform
  static bool get isFileSupported => !kIsWeb;
}

