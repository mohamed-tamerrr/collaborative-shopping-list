import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/services/local_storage_service.dart';
import 'package:final_project/core/services/notification_service.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_images.dart';
import 'package:final_project/featrues/home/presentation/views/notifications_view.dart';
import 'package:final_project/featrues/home/presentation/views/profile_view.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/app_bar_icon.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({super.key});
  //! Looking for better icon for first icon button

  FirebaseServices get _firebaseServices => FirebaseServices();
  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    final user = _firebaseServices.currentUser;
    if (user == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 50,
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _firebaseServices.userProfileStream(user.uid),
        builder: (context, snapshot) {
          final data = snapshot.data?.data();
          final String name = data?['name'] ?? user.displayName ?? 'Guest';
          final String email = data?['email'] ?? user.email ?? '';
          final String? photoUrl = data?['photoUrl'] as String?;

          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfileView()),
                  );
                },
                child: FutureBuilder<File?>(
                  future: photoUrl != null && photoUrl!.startsWith('local:')
                      ? LocalStorageService.getProfilePhotoFile(
                          photoUrl!.substring(6))
                      : Future.value(null),
                  builder: (context, snapshot) {
                    if (photoUrl != null && photoUrl!.startsWith('local:')) {
                      // Local photo
                      if (snapshot.hasData && snapshot.data != null) {
                        return CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.lightGrey,
                          backgroundImage: FileImage(snapshot.data!),
                        );
                      }
                      return CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.lightGrey,
                        child: ClipOval(
                          child: Image.asset(
                            AppImages.avatar,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else if (photoUrl != null && photoUrl!.isNotEmpty) {
                      // Network photo (backward compatibility)
                      return CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.lightGrey,
                        backgroundImage: NetworkImage(photoUrl!),
                        onBackgroundImageError: (_, __) {},
                        child: ClipOval(
                          child: Image.asset(
                            AppImages.avatar,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      // No photo
                      return CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.lightGrey,
                        child: ClipOval(
                          child: Image.asset(
                            AppImages.avatar,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navyBlue,
                    ),
                  ),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const AppBarIcon(
                //! THIS ONE
                icon: Icons.workspace_premium,
                color: AppColors.mediumNavy,
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationsView(),
                    ),
                  );
                },
                child: StreamBuilder<int>(
                  stream: _notificationService.getUnreadCount(user.uid),
                  builder: (context, snapshot) {
                    final count = snapshot.data ?? 0;
                    final hasNotifications = count > 0;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AppBarIcon(
                          icon: hasNotifications
                              ? Icons.notifications
                              : Icons.notifications_outlined,
                          color: hasNotifications
                              ? AppColors.primaryColor
                              : AppColors.grey,
                        ),
                        if (count > 0)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                count > 99 ? '99+' : count.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
