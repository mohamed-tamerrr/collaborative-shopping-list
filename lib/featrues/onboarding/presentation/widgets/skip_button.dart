import 'package:final_project/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double fontSize;
  final Color color;

  const SkipButton({
    super.key,
    required this.onPressed,
    this.fontSize = 14,
    this.color = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'Skip',
        style: TextStyle(
          color: color.withValues(alpha: 0.7),
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
