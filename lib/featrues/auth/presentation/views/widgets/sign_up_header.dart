import 'package:final_project/core/utils/app_styles.dart';
import 'package:final_project/core/widgets/unified_back_button.dart';
import 'package:flutter/material.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UnifiedBackButton(),
        SizedBox(height: 30),
        Text('Create Account', style: AppStyles.heading1()),
        SizedBox(height: 5),
        Text(
          'Join us and start shopping',
          style: AppStyles.bodyLarge(),
        ),
      ],
    );
  }
}
