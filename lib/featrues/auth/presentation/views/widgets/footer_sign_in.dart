import 'package:final_project/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class FooterSignIn extends StatelessWidget {
  const FooterSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account?", style: AppStyles.bodyLarge()),
        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          child: Text('Sign In', style: AppStyles.link()),
        ),
      ],
    );
  }
}
