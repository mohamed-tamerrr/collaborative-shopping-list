import 'package:final_project/core/services/local_storage_service.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_styles.dart';
import 'package:final_project/featrues/auth/presentation/views/login_view.dart';
import 'package:final_project/featrues/auth/presentation/views/sign_up_view.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/home_view.dart';
import 'package:final_project/featrues/home/presentation/views/profile_view.dart';
import 'package:final_project/featrues/onboarding/presentation/views/onboarding_view.dart';
import 'package:final_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'featrues/auth/presentation/views/forgot_password_screen.dart';
import 'featrues/auth/presentation/views/reset_password_screen.dart';
import 'featrues/splash/presentation/views/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // TEMPORARY: Reset onboarding to test (REMOVE THIS AFTER TESTING)
  await LocalStorageService.resetOnboarding();
  print('Onboarding reset - you should see it after splash screen');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListCubit(),
      child: MaterialApp(
        title: 'ListMate',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.navyBlue,
            primary: AppColors.orange,
            secondary: AppColors.mediumNavy,
          ),
          inputDecorationTheme: AppStyles.inputDecorationTheme,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: AppStyles.primaryButtonStyle,
          ),
          textButtonTheme: TextButtonThemeData(
            style: AppStyles.textButtonStyle,
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: AppStyles.outlinedButtonStyle,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.mediumNavy),
            titleTextStyle: TextStyle(
              color: AppColors.mediumNavy,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        routes: {
          '/home': (context) => const HomeView(),
          '/login': (context) => const SignInScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/profile': (context) => const ProfileView(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/reset-password': (context) => const ResetPasswordScreen(),
          '/onboarding': (context) => const OnboardingView(),
        },

        home: const SplashScreen(),

        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
