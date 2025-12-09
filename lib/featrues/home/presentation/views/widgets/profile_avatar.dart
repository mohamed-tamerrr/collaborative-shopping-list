import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/services/local_storage_service.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final bool isUploading;
  final VoidCallback onPickImage;

  const ProfileAvatar({
    super.key,
    required this.photoUrl,
    required this.isUploading,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<File?>(
          future:
              photoUrl != null && photoUrl!.startsWith('local:')
              ? LocalStorageService.getProfilePhotoFile(
                  photoUrl!.substring(6),
                )
              : Future.value(null),
          builder: (context, snapshot) {
            if (photoUrl != null &&
                photoUrl!.startsWith('local:')) {
              if (snapshot.hasData && snapshot.data != null) {
                return CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.lightGrey,
                  backgroundImage: FileImage(snapshot.data!),
                );
              }
              return _defaultAvatar();
            } else if (photoUrl != null &&
                photoUrl!.isNotEmpty) {
              return CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.lightGrey,
                backgroundImage: NetworkImage(photoUrl!),
                onBackgroundImageError: (_, __) {},
                child: const Icon(
                  Icons.person,
                  size: 48,
                  color: AppColors.grey,
                ),
              );
            } else {
              return _defaultAvatar();
            }
          },
        ),
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
                        valueColor:
                            AlwaysStoppedAnimation<Color>(
                              AppColors.white,
                            ),
                      ),
                    )
                  : const Icon(
                      Icons.edit,
                      size: 16,
                      color: AppColors.white,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  CircleAvatar _defaultAvatar() {
    return const CircleAvatar(
      radius: 60,
      backgroundColor: AppColors.lightGrey,
      child: Icon(Icons.person, size: 48, color: AppColors.grey),
    );
  }
}
