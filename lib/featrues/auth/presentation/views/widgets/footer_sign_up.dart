import 'package:final_project/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class FooterSignUp extends StatelessWidget {
  const FooterSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: AppStyles.bodyLarge(),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/signup'),
              child: Text('Sign Up', style: AppStyles.link()),
            ),
          ],
        ),
      ],
    );
  }
}
