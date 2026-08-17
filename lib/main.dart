import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/navigation/app_navigator.dart';
import 'core/services/sound_service.dart';
import 'core/services/storage_service.dart';
import 'providers/converter_provider.dart';
import 'providers/shop_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/shop/shop_screen.dart';
import 'screens/splash_screen.dart';
import 'widgets/coin_reward_listener.dart';

late final ThemeProvider appThemeProvider;
late final ConverterProvider appConverterProvider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.init();
  await SoundService.instance.init();

  appThemeProvider = ThemeProvider();
  await appThemeProvider.init();

  appConverterProvider = ConverterProvider();
  await appConverterProvider.init();

  runApp(const UnitProApp());
}

class UnitProApp extends StatelessWidget {
  const UnitProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appThemeProvider),
        ChangeNotifierProvider.value(value: appConverterProvider),
        ChangeNotifierProvider.value(value: SoundService.instance),
        ChangeNotifierProvider(create: (_) => ShopProvider()..init()),
      ],
      child: Consumer2<ThemeProvider, ShopProvider>(
        builder: (context, theme, shop, _) {
          final preset = shop.activeTheme;
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: theme.isDarkMode ? Brightness.light : Brightness.dark,
          ));

          return MaterialApp(
            navigatorKey: rootNavigatorKey,
            title: 'UnitPro',
            debugShowCheckedModeBanner: false,
            theme: preset.lightTheme(),
            darkTheme: preset.darkTheme(),
            themeMode: theme.themeMode,
            locale: const Locale('en'),
            builder: (context, child) => CoinRewardListener(child: child ?? const SizedBox.shrink()),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: const SplashScreen(),
            routes: {
              '/shop': (_) => const ShopScreen(),
              '/privacy': (_) => const PrivacyPolicyScreen(),
            },
          );
        },
      ),
    );
  }
}
