import 'package:flutter/material.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'splash_logo.dart';

class SplashLogoSection extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  const SplashLogoSection({
    super.key,
    required this.fadeAnimation,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fadeAnimation,
      builder: (_, child) {
        return Opacity(
          opacity: fadeAnimation.value,
          child: Transform.scale(
            scale: scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SplashLogo(),
          const SizedBox(height: 32),
          const Text(
            'List-Mate',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Create and share your lists with anyone, anytime',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w300,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
