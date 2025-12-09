import 'package:flutter/material.dart';
import 'profile_info_tile.dart';
import 'package:final_project/core/utils/app_styles.dart';

class ProfileInfoSection extends StatelessWidget {
  final String name;
  final String email;

  const ProfileInfoSection({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileInfoTile(
          icon: Icons.person,
          title: 'Name',
          value: name,
        ),
        const SizedBox(height: AppStyles.spacingM),
        ProfileInfoTile(
          icon: Icons.email,
          title: 'Email',
          value: email,
        ),
      ],
    );
  }
}
