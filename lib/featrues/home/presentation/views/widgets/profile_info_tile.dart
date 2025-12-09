import 'package:flutter/material.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_styles.dart';

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: AppColors.lightGrey.withValues(alpha: 0.4),
      child: ListTile(
        leading: Icon(icon, color: AppColors.mediumNavy),
        title: Text(title, style: AppStyles.label()),
        subtitle: Text(value, style: AppStyles.bodyMedium()),
      ),
    );
  }
}
