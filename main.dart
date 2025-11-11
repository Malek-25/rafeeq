import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_config.dart';
import 'core/providers/app_provider.dart';
import 'core/providers/market_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/orders_provider.dart';
import 'core/theme/theme_provider.dart';

import 'screens/auth/sign_in.dart';
import 'screens/auth/sign_up.dart';
import 'screens/auth/reset_password.dart';
import 'screens/splash.dart';
import 'screens/language_selector.dart';
import 'screens/home.dart';
import 'screens/housing_list.dart';
import 'screens/wallet.dart';
import 'screens/orders.dart';
import 'screens/reviews.dart';
import 'screens/suggestions.dart';
import 'screens/profile.dart';
import 'screens/settings.dart';
import 'screens/provider_add_housing.dart';
import 'screens/provider_add_service.dart';

import 'features/market/student_market.dart';
import 'features/market/product_details.dart';
import 'features/market/add_product.dart';

import 'features/chat/inbox_screen.dart';
import 'features/chat/chat_thread_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RafeeqApp());
}

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
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (_, theme, locale, __) {
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
            ],
            initialRoute: '/splash',
            routes: {
              '/splash': (_) => const SplashScreen(),
              '/language': (_) => const LanguageSelectorScreen(),
              '/auth/sign-in': (_) => const SignInScreen(),
              '/auth/sign-up': (_) => const SignUpScreen(),
              '/auth/reset': (_) => const ResetPasswordScreen(),
              '/': (_) => const HomeScreen(),
              '/housing': (_) => const HousingListScreen(),
              '/wallet': (_) => const WalletScreen(),
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
            },
          );
        },
      ),
    );
  }
}
