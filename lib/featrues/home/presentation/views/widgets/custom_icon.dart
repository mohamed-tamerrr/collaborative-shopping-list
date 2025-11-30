import 'package:final_project/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({super.key, this.icon, this.onPressed});
  final IconData? icon;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.lightGrey,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.mediumNavy),
      ),
    );
  }
}
