import 'package:flutter/material.dart';
import 'package:final_project/core/utils/app_colors.dart';

class SplashButtonSection extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final VoidCallback onPressed;

  const SplashButtonSection({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: AnimatedBuilder(
        animation: fadeAnimation,
        builder: (_, child) {
          return Opacity(
            opacity: fadeAnimation.value,
            child: Transform.translate(
              offset: slideAnimation.value * 50,
              child: child,
            ),
          );
        },
        child: _buildButton(),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.orange, AppColors.lightOrange],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Explore List-Mate',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, color: AppColors.white),
          ],
        ),
      ),
    );
  }
}
