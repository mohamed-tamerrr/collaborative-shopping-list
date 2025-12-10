import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/services/notification_service.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/featrues/home/presentation/views/notifications_view.dart';
import 'package:final_project/featrues/home/presentation/views/profile_view.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({super.key});

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
                child: UserAvatar(name: name, photoUrl: photoUrl, radius: 20),
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
                    style: const TextStyle(fontSize: 12, color: AppColors.grey),
                  ),
                ],
              ),

              const Spacer(),

              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NotificationsView(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // مساحة ضغط ثابتة
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications_none,
                          size: 28,
                          color: AppColors.grey,
                        ),

                        Positioned(
                          right: -2,
                          top: -2,
                          child: StreamBuilder<int>(
                            stream: _notificationService.getUnreadCount(
                              user.uid,
                            ),
                            builder: (context, snapshot) {
                              final count = snapshot.data ?? 0;

                              if (count == 0) {
                                return const SizedBox(width: 1, height: 1);
                              }

                              return Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  count > 99 ? '99+' : count.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
