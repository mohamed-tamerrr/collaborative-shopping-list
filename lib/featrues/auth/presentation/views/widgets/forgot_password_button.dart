import 'package:final_project/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () =>
            Navigator.pushNamed(context, '/forgot-password'),
        child: Text('Forgot Password?', style: AppStyles.link()),
      ),
    );
  }
}
