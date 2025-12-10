import 'package:final_project/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final bool isActive;
  final Duration duration;

  const PageIndicator({
    super.key,
    required this.isActive,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.orange
            : AppColors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
