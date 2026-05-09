import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;
  void setMode(ThemeMode m) {
    _mode = m;
    notifyListeners();
  }

  // Brand Colors - Bold and vibrant
  static const Color primaryBlue = Color(0xFF1565C0); // Deep vibrant blue
  static const Color primaryDark = Color(0xFF0D47A1); // Even deeper for headers
  static const Color accentOrange = Color(0xFFFF6D00); // Bright orange accent
  static const Color accentGold = Color(0xFFFFAB00); // Warm gold
  static const Color successGreen = Color(0xFF00C853); // Vivid green
  static const Color errorRed = Color(0xFFD50000); // Strong red
  static const Color surfaceLight = Color(0xFFF8FAFC); // Slightly blue-tinted white
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A2E); // Near black with warmth
  static const Color textSecondary = Color(0xFF546E7A); // Readable grey

  // Legacy aliases
  static const Color asuNavy = primaryBlue;
  static const Color asuGold = accentGold;

  ThemeData get light => ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryBlue,
        scaffoldBackgroundColor: surfaceLight,
        colorScheme: const ColorScheme.light(
          primary: primaryBlue,
          onPrimary: Colors.white,
          primaryContainer: Color(0xFFBBDEFB),
          onPrimaryContainer: Color(0xFF0D47A1),
          secondary: accentOrange,
          onSecondary: Colors.white,
          secondaryContainer: Color(0xFFFFE0B2),
          onSecondaryContainer: Color(0xFFE65100),
          tertiary: accentGold,
          onTertiary: Colors.black,
          error: errorRed,
          onError: Colors.white,
          surface: cardLight,
          onSurface: textPrimary,
          surfaceContainerHighest: Color(0xFFEEF2F6),
          outline: Color(0xFFBDBDBD),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 4,
          surfaceTintColor: Colors.transparent,
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white, size: 24),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.08),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          color: cardLight,
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 3,
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            elevation: 2,
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryBlue,
            side: const BorderSide(color: primaryBlue, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryBlue,
            textStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: accentOrange,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryBlue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: errorRed, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
          labelStyle: const TextStyle(color: textSecondary),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFEEF2F6),
          selectedColor: primaryBlue,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          secondaryLabelStyle: const TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFEEEEEE),
          thickness: 1,
          space: 1,
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          subtitleTextStyle: TextStyle(
            fontSize: 13,
            color: textSecondary,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: primaryBlue,
          unselectedItemColor: Color(0xFF9E9E9E),
          type: BottomNavigationBarType.fixed,
          elevation: 12,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 8,
          height: 72,
          indicatorColor: primaryBlue.withOpacity(0.15),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: primaryBlue);
            }
            return const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF757575));
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: primaryBlue, size: 26);
            }
            return const IconThemeData(color: Color(0xFF757575), size: 24);
          }),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
        fontFamily: 'Roboto',
        typography: Typography.material2021(),
      );

  ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF42A5F5),
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF42A5F5), // Lighter blue for dark mode
          onPrimary: Colors.white,
          primaryContainer: Color(0xFF1565C0),
          onPrimaryContainer: Color(0xFFBBDEFB),
          secondary: Color(0xFFFFAB40),
          onSecondary: Colors.black,
          secondaryContainer: Color(0xFFE65100),
          onSecondaryContainer: Color(0xFFFFE0B2),
          tertiary: Color(0xFFFFD740),
          error: Color(0xFFFF5252),
          onError: Colors.white,
          surface: Color(0xFF1E1E1E),
          onSurface: Color(0xFFECEFF1),
          surfaceContainerHighest: Color(0xFF2A2A2A),
          outline: Color(0xFF616161),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 4,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white, size: 24),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          color: const Color(0xFF1E1E1E),
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 4,
            backgroundColor: const Color(0xFF42A5F5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            elevation: 2,
            backgroundColor: const Color(0xFF42A5F5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF42A5F5),
            side: const BorderSide(color: Color(0xFF42A5F5), width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFAB40),
          foregroundColor: Colors.black,
          elevation: 6,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFF424242), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFF424242), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFF42A5F5), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          hintStyle: const TextStyle(color: Color(0xFF757575)),
          labelStyle: const TextStyle(color: Color(0xFF9E9E9E)),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF2A2A2A),
          selectedColor: const Color(0xFF42A5F5),
          labelStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF333333),
          thickness: 1,
          space: 1,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF1E1E1E),
          elevation: 8,
          height: 72,
          indicatorColor: const Color(0xFF42A5F5).withOpacity(0.2),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF42A5F5));
            }
            return const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9E9E9E));
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                  color: Color(0xFF42A5F5), size: 26);
            }
            return const IconThemeData(
                color: Color(0xFF9E9E9E), size: 24);
          }),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
        fontFamily: 'Roboto',
        typography: Typography.material2021(),
      );
}
