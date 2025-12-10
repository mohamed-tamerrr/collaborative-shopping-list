import 'dart:io';

import 'package:final_project/core/services/local_storage_service.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final double radius;
  final Color backgroundColor;
  final Color textColor;

  const UserAvatar({
    super.key,
    this.photoUrl,
    required this.name,
    this.radius = 20,
    this.backgroundColor = AppColors.lightGrey,
    this.textColor = AppColors.navyBlue,
  });

  @override
  Widget build(BuildContext context) {
   
    if (photoUrl != null && photoUrl!.startsWith('local:')) {
      return FutureBuilder<File?>(
        future: LocalStorageService.getProfilePhotoFile(photoUrl!.substring(6)),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return CircleAvatar(
              radius: radius,
              backgroundColor: backgroundColor,
              backgroundImage: FileImage(snapshot.data!),
            );
          }

          return _buildInitialsAvatar();
        },
      );
    }

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        backgroundImage: NetworkImage(photoUrl!),
      );
    }

    return _buildInitialsAvatar();
  }

  Widget _buildInitialsAvatar() {
    String initials = '';
    if (name.isNotEmpty) {
      initials = name[0].toUpperCase();
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: initials.isNotEmpty
          ? Text(
              initials,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: radius,
              ),
            )
          : Icon(Icons.person, color: Colors.grey[600], size: radius * 1.2),
    );
  }
}
