import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final bool isUploading;
  final VoidCallback onPickImage;

  const ProfileAvatar({
    super.key,
    required this.photoUrl,
    required this.name,
    required this.isUploading,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        UserAvatar(photoUrl: photoUrl, name: name, radius: 60),
        Positioned(
          bottom: 0,
          right: 4,
          child: GestureDetector(
            onTap: isUploading ? null : onPickImage,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.orange,
              child: isUploading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                  : const Icon(Icons.edit, size: 16, color: AppColors.white),
            ),
          ),
        ),
      ],
    );
  }
}
