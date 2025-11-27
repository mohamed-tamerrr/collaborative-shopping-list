import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/featrues/auth/presentation/views/login_view.dart';
import 'package:final_project/featrues/auth/presentation/views/sign_up_view.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/home_view.dart';
import 'package:final_project/featrues/home/presentation/views/profile_view.dart';
import 'package:final_project/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'featrues/auth/presentation/views/forgot_password_screen.dart';
import 'featrues/auth/presentation/views/reset_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListCubit(),
      child: MaterialApp(
        title: 'ShopEasy',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.white,
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
        routes: {
          '/home': (context) => const HomeView(),
          '/login': (context) => const SignInScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/profile': (context) => const ProfileView(),
          '/forgot-password': (context) =>
              const ForgotPasswordScreen(),
          '/reset-password': (context) =>
              const ResetPasswordScreen(),
        },
        home: StreamBuilder<User?>(
          stream: FirebaseServices().authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData) {
              return const HomeView();
            }
            return const SignInScreen();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
