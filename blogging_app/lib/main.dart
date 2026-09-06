import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_config/app_config.dart';
import 'network/service/api_service.dart';
import 'screens/home/view/home_screen.dart';
import 'screens/onboard/view/login_screen.dart';
import 'screens/onboard/view/onboarding_screen.dart';
import 'screens/onboard/view/signup_screen.dart';
import 'screens/onboard/view_model/login_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runBloggingApp(
    flavor: Flavor.prod,
    baseUrl: 'https://api.example.com/api/v1/',
  );
}

void runBloggingApp({
  required Flavor flavor,
  required String baseUrl,
}) {
  AppConfig.create(
    appName: 'Blogging App',
    baseUrl: baseUrl,
    flavor: flavor,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => LoginProvider(ApiService())..initialize(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.shared.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        useMaterial3: true,
      ),
      home: const AppRouter(),
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        OnboardingScreen.routeName: (_) => const OnboardingScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        SignupScreen.routeName: (_) => const SignupScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
      },
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return switch (context.watch<LoginProvider>().stage) {
      AppStage.splash => const SplashScreen(),
      AppStage.onboarding => const OnboardingScreen(),
      AppStage.login => const LoginScreen(),
      AppStage.home => const HomeScreen(),
    };
  }
}