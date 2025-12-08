import 'package:final_project/core/services/local_storage_service.dart';
import 'package:final_project/featrues/splash/presentation/views/widgets/splash_animated_content.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/core/utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Auto-navigation after 8 seconds
    Future.delayed(const Duration(seconds: 8), _navigate);
  }

  Future<void> _navigate() async {
    if (!mounted) return;

    print('=== SPLASH NAVIGATION START ===');

    // Check if onboarding is completed
    final isOnboardingCompleted =
        await LocalStorageService.isOnboardingCompleted();

    print('Onboarding completed status: $isOnboardingCompleted');

    if (!isOnboardingCompleted) {
      // Show onboarding if not completed
      print('✅ Onboarding NOT completed - Navigating to OnboardingView');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
      return;
    }

    // If onboarding is completed, check auth and navigate
    print('❌ Onboarding already completed - Skipping to login/home');
    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (user != null) {
      print('User is logged in - Navigating to /home');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      print('User is NOT logged in - Navigating to /login');
      Navigator.pushReplacementNamed(context, '/login');
    }

    print('=== SPLASH NAVIGATION END ===');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyBlue,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.navyBlue, AppColors.mediumNavy],
          ),
        ),
        child: SafeArea(child: SplashAnimatedContent(onGetStarted: _navigate)),
      ),
    );
  }
}
