import 'package:final_project/featrues/auth/presentation/views/login_view.dart';
import 'package:final_project/featrues/auth/presentation/views/sign_up_view.dart';
import 'package:final_project/featrues/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'featrues/auth/presentation/views/forgot_password_screen.dart';
import 'featrues/auth/presentation/views/reset_password_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEasy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A2647),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      initialRoute:
          '/', // This makes SplashScreen the first screen
      routes: {
        '/': (context) =>
            const SplashScreen(), // SplashScreen is the home
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgot-password': (context) =>
            const ForgotPasswordScreen(),
        '/reset-password': (context) =>
            const ResetPasswordScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
