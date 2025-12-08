import 'package:final_project/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const SignUpButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: AppStyles.primaryButtonStyle,
      child: isLoading
          ? AppStyles.loadingIndicator()
          : const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
