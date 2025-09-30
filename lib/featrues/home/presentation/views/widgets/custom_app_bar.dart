import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_images.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/app_bar_icon.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});
  //! Looking for better icon for first icon button
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: CircleAvatar(
                child: Image.asset(
                  AppImages.avatar,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anjali Arora',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navyBlue,
                  ),
                ),
                Text(
                  'Anjali@shreyansign.com',
                  style: TextStyle(fontSize: 12, color: AppColors.grey),
                ),
              ],
            ),
            Spacer(),
            AppBarIcon(
              //! THIS ONE
              icon: Icons.workspace_premium,
              color: AppColors.mediumNavy,
            ),
            SizedBox(width: 16),
            AppBarIcon(
              icon: Icons.notifications_outlined,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
