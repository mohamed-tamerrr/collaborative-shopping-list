import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class GroupAvatars extends StatelessWidget {
  const GroupAvatars({
    super.key,
    required this.membersData, // List of {photoUrl, name, email}
    this.size = 35,
    this.onAvatarTap,
  });

  final List<Map<String, dynamic>> membersData;
  final double size;
  final void Function(String email)? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    if (membersData.isEmpty) {
      return const SizedBox.shrink();
    }

    const overlap = 15.0;
    final remaining = membersData.length > 2 ? membersData.length - 2 : 0;

    // Calculate width based on number of avatars to show
    final avatarsToShow = membersData.length > 2 ? 2 : membersData.length;
    final width =
        size +
        (avatarsToShow > 1 ? (size - overlap) * (avatarsToShow - 1) : 0) +
        (remaining > 0 ? (size - overlap) : 0);

    return SizedBox(
      height: size,
      width: width,
      child: Stack(
        children: [
          if (membersData.isNotEmpty)
            Positioned(left: 0, child: _buildAvatar(membersData[0], 0)),

          if (membersData.length > 1)
            Positioned(
              left: size - overlap,
              child: _buildAvatar(membersData[1], 1),
            ),

          if (remaining > 0)
            Positioned(
              left: 2 * (size - overlap),
              child: GestureDetector(
                onTap: onAvatarTap != null && membersData.length > 2
                    ? () {
                        // Show all remaining emails
                        _showAllMembersDialog(
                          context,
                          membersData
                              .sublist(2)
                              .map((m) => m['email'] as String? ?? '')
                              .where((e) => e.isNotEmpty)
                              .toList(),
                        );
                      }
                    : null,
                child: CircleAvatar(
                  radius: size / 2,
                  backgroundColor: AppColors.lightGrey,
                  child: Text(
                    '+$remaining',
                    style: TextStyle(
                      color: AppColors.mediumNavy,
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

  Widget _buildAvatar(Map<String, dynamic> member, int index) {
    final photoUrl = member['photoUrl'] as String?;
    final name = member['name'] as String? ?? '';
    final email = member['email'] as String?;

    final avatarWidget = UserAvatar(
      name: name,
      photoUrl: photoUrl,
      radius: size / 2,
    );

    if (onAvatarTap != null && email != null) {
      return GestureDetector(
        onTap: () => onAvatarTap!(email),
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }

  void _showAllMembersDialog(BuildContext context, List<String> emails) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Members'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: emails
              .map(
                (email) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(email),
                ),
              )
              .toList(),
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
