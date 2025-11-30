import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

/// Unified back button widget for consistent navigation across all screens
class UnifiedBackButton extends StatelessWidget {
  const UnifiedBackButton({super.key, this.onPressed, this.iconColor});

  final VoidCallback? onPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: AppStyles.backButtonDecoration,
        child: Icon(Icons.arrow_back, color: iconColor ?? AppColors.mediumNavy),
      ),
    );
  }
}
