import 'package:final_project/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppBarIcon extends StatelessWidget {
  const AppBarIcon({super.key, required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(64),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
