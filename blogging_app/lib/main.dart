import 'package:blogging_app/screens/add_blog/view_model/blog_provider.dart';
import 'package:blogging_app/screens/add_blog/views/add_blog_screen.dart';
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
    userBaseUrl: 'https://api.example.com/api/user/',
  );
}

void runBloggingApp({
  required Flavor flavor,
  required String userBaseUrl,
}) {
  AppConfig.create(
    appName: 'Blogging App',
    userBaseUrl: userBaseUrl,
    flavor: flavor,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginProvider(ApiService())..initialize(),
        ),

        ChangeNotifierProvider(
          create: (_) => BlogProvider(ApiService()),
        ),
      ],
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
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
        AddBlogScreen.routeName: (_) => const AddBlogScreen(),
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