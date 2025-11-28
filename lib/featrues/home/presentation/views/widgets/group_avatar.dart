import 'dart:io';

import 'package:final_project/core/services/local_storage_service.dart';
import 'package:final_project/core/utils/app_images.dart';
import 'package:flutter/material.dart';

class GroupAvatars extends StatelessWidget {
  const GroupAvatars({
    super.key,
    required this.imageUrls,
    this.size = 35,
    this.memberEmails,
    this.onAvatarTap,
  });
  final List<String?> imageUrls; // Can be null for users without photos
  final double size;
  final List<String>? memberEmails; // Email for each member (same order as imageUrls)
  final void Function(String email)? onAvatarTap; // Callback when avatar is tapped

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    const overlap = 15.0;
    final remaining = imageUrls.length > 2
        ? imageUrls.length - 2
        : 0;

    // Calculate width based on number of avatars to show
    final avatarsToShow = imageUrls.length > 2 ? 2 : imageUrls.length;
    final width = size + (avatarsToShow > 1 ? (size - overlap) * (avatarsToShow - 1) : 0) + (remaining > 0 ? (size - overlap) : 0);

    return SizedBox(
      height: size,
      width: width,
      child: Stack(
        children: [
          if (imageUrls.isNotEmpty)
            Positioned(
              left: 0,
              child: _buildAvatar(
                imageUrls[0],
                0,
                memberEmails != null && memberEmails!.isNotEmpty
                    ? memberEmails![0]
                    : null,
              ),
            ),

          if (imageUrls.length > 1)
            Positioned(
              left: size - overlap,
              child: _buildAvatar(
                imageUrls[1],
                1,
                memberEmails != null && memberEmails!.length > 1
                    ? memberEmails![1]
                    : null,
              ),
            ),

          if (remaining > 0)
            Positioned(
              left: 2 * (size - overlap),
              child: GestureDetector(
                onTap: onAvatarTap != null && memberEmails != null && memberEmails!.length > 2
                    ? () {
                        // Show all remaining emails
                        _showAllMembersDialog(context, memberEmails!.sublist(2));
                      }
                    : null,
                child: CircleAvatar(
                  radius: size / 2,
                  backgroundColor: const Color(0xFFF3EFFF),
                  child: Text(
                    '+$remaining',
                    style: TextStyle(
                      color: Colors.purple[600],
                      fontWeight: FontWeight.w600,
                      fontSize: size / 2.5,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? imageUrl, int index, String? email) {
    final avatarWidget = _buildAvatarWidget(imageUrl);

    if (onAvatarTap != null && email != null) {
      return GestureDetector(
        onTap: () => onAvatarTap!(email),
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }

  Widget _buildAvatarWidget(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: const Color(0xFFF3EFFF),
        child: Icon(
          Icons.person,
          size: size / 1.5,
          color: Colors.purple[600],
        ),
      );
    }

    // Check if it's a local photo
    if (imageUrl.startsWith('local:')) {
      final uid = imageUrl.substring(6); // Remove 'local:' prefix
      return FutureBuilder<File?>(
        future: LocalStorageService.getProfilePhotoFile(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return CircleAvatar(
              radius: size / 2,
              backgroundColor: const Color(0xFFF3EFFF),
              backgroundImage: FileImage(snapshot.data!),
            );
          }
          return CircleAvatar(
            radius: size / 2,
            backgroundColor: const Color(0xFFF3EFFF),
            child: Icon(
              Icons.person,
              size: size / 1.5,
              color: Colors.purple[600],
            ),
          );
        },
      );
    }

    // Network photo (backward compatibility)
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: const Color(0xFFF3EFFF),
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (_, __) {},
      child: Icon(
        Icons.person,
        size: size / 1.5,
        color: Colors.purple[600],
      ),
    );
  }

  void _showAllMembersDialog(BuildContext context, List<String> emails) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Members'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: emails.map((email) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(email),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
