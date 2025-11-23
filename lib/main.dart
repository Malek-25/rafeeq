import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';

// Import all your screens and providers as before
import 'core/app_config.dart';
import 'core/providers/app_provider.dart';
import 'core/providers/market_provider.dart';
import 'core/providers/housing_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/orders_provider.dart';
import 'core/providers/chat_provider.dart';
import 'core/providers/services_provider.dart';
import 'core/theme/theme_provider.dart';
import 'core/firebase/firebase_flags.dart';
import 'core/services/biometric_service.dart';
import 'core/utils/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/splash.dart'; // Your actual splash screen
import 'screens/home.dart';
import 'screens/auth/sign_in.dart';
// ... other screen imports
import 'screens/auth/sign_up.dart';
import 'screens/auth/reset_password.dart';
import 'screens/language_selector.dart';
import 'screens/housing_list.dart';
import 'screens/services_list.dart';
import 'screens/service_details.dart';
import 'screens/orders.dart';
import 'screens/reviews.dart';
import 'screens/suggestions.dart';
import 'screens/profile.dart';
import 'screens/settings.dart';
import 'screens/privacy_policy.dart';
import 'screens/terms_of_service.dart';
import 'screens/about.dart';
import 'screens/provider_add_housing.dart';
import 'screens/provider_add_service.dart';
import 'features/market/student_market.dart';
import 'features/market/product_details.dart';
import 'features/market/add_product.dart';
import 'features/chat/inbox_screen.dart';
import 'features/chat/chat_thread_screen.dart';


// The main entry point of the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kUseFirebase) {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
    }
  }

  // --- MODIFICATION: Run the PreSplashScreen first ---
  runApp(const PreSplashScreen());
}


// A temporary, top-level widget whose only job is to show the real splash screen
// and then navigate to the main app.
class PreSplashScreen extends StatelessWidget {
  const PreSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // The home is your real SplashScreen
      home: Builder(
        builder: (context) {
          // Use a timer to navigate after 3 seconds
          Timer(const Duration(seconds: 3), () {
            // After the timer, push the main app and remove the splash screen
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const RafeeqApp()),
                  (Route<dynamic> route) => false,
            );
          });
          // While waiting, show the actual splash screen
          return const SplashScreen();
        },
      ),
    );
  }
}


// This is your main application widget, it will be loaded AFTER the splash screen.
class RafeeqApp extends StatelessWidget {
  const RafeeqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => MarketProvider()),
        ChangeNotifierProvider(create: (_) => HousingProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ServicesProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (_, theme, locale, __) {
          final isRTL = locale.locale.languageCode == 'ar';

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConfig.appName,
            theme: theme.light,
            darkTheme: theme.dark,
            themeMode: theme.mode,
            locale: locale.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            builder: (context, child) {
              return Directionality(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                child: child!,
              );
            },
            // All your routes remain here for navigation within the app
            routes: {
              '/': (_) => const AuthWrapper(), // Set AuthWrapper as the default route
              '/language': (_) => const LanguageSelectorScreen(),
              '/auth/sign-in': (_) => const SignInScreen(),
              '/auth/sign-up': (_) => const SignUpScreen(),
              '/auth/reset': (_) => const ResetPasswordScreen(),
              '/home': (_) => const HomeScreen(),
              '/housing': (_) => const HousingListScreen(),
              '/services': (_) => const ServicesListScreen(),
              '/services/details': (_) => const ServiceDetailsScreen(),
              '/orders': (_) => const OrdersScreen(),
              '/reviews': (_) => const ReviewsScreen(),
              '/suggestions': (_) => const SuggestionsScreen(),
              '/profile': (_) => const ProfileScreen(),
              '/settings': (_) => const SettingsScreen(),
              '/provider/add-housing': (_) => const ProviderAddHousingScreen(),
              '/provider/add-service': (_) => const ProviderAddServiceScreen(),
              '/market': (_) => const StudentMarketScreen(),
              '/market/details': (_) => const ProductDetailsScreen(),
              '/market/add': (_) => const AddProductScreen(),
              '/chat/inbox': (_) => const InboxScreen(),
              '/chat/thread': (_) => const ChatThreadScreen(),
              '/privacy-policy': (_) => const PrivacyPolicyScreen(),
              '/terms-of-service': (_) => const TermsOfServiceScreen(),
              '/about': (_) => const AboutScreen(),
            },
          );
        },
      ),
    );
  }
}

// AuthWrapper with proper initialization
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> with WidgetsBindingObserver {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // When app is closed/minimized, sign out the user
    if (state == AppLifecycleState.detached || state == AppLifecycleState.paused) {
      final appState = context.read<AppState>();
      if (appState.isAuthenticated) {
        // Clear biometric credentials when app is closed
        BiometricService.clearBiometricCredentials();
        appState.signOut();
      }
    }
  }

  Future<void> _initializeApp() async {
    try {
      // Load authentication state and locale
      final appState = context.read<AppState>();
      final localeProvider = context.read<LocaleProvider>();
      
      await Future.wait([
        appState.loadAuthState(),
        localeProvider.loadLocale(),
      ]);
    } catch (e) {
      debugPrint('Error initializing app: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final appState = context.watch<AppState>();

    if (appState.isAuthenticated) {
      return const HomeScreen();
    } else {
      return const SignInScreen();
    }
  }
}
