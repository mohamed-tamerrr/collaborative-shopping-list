import 'package:flutter/material.dart';
import 'package:final_project/core/utils/app_styles.dart';

class SignOutButton extends StatelessWidget {
  final VoidCallback onSignOut;

  const SignOutButton({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onSignOut,
        icon: const Icon(Icons.logout),
        label: const Text('Sign Out'),
        style: AppStyles.primaryButtonStyle.copyWith(
          minimumSize: MaterialStatePropertyAll(
            const Size(double.infinity, 56),
          ),
        ),
      ),
    );
  }
}
