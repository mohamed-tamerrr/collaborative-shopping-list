
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/services/notification_service.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  // Stateless لأنها مش محتاجة state داخلي… كل حاجة جاية من StreamBuilder.
  const NotificationsView({super.key});

  static Future<void> showNotificationMessage(
      //تعرض Snackbar لما تدوسي على إشعار.
    BuildContext context, {
    required NotificationService notificationService, // mark as read
    required String notificationId,
    String? senderUserId,
    String? listId,
  }) async {
    final firebaseServices = FirebaseServices();
    String senderName = 'Unknown User'; // default value
    String listName = 'Unknown List';// default value

    // Get sender name/email
    if (senderUserId != null) {
      try {
        final senderDoc = await firebaseServices.getUserByUid(senderUserId);
        if (senderDoc.exists) {
          final senderData = senderDoc.data();
          senderName =
              senderData?['name'] ?? senderData?['email'] ?? 'Unknown User';
        }
      } catch (e) {
        // Handle error silently
      }
    }

    // Get list name
    if (listId != null) {
      try {
        final listDoc = await FirebaseFirestore.instance
            .collection('lists')
            .doc(listId)
            .get();
        // get the list from firestore
        if (listDoc.exists) {
          final listData = listDoc.data();
          listName = listData?['name'] ?? 'Unknown List';
          // get list name
        }
      } catch (e) {
        // Handle error silently
      }
    }

    // Show SnackBar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 16),
              children: [
                TextSpan(
                  text: senderName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' invited you to the list '),
                TextSpan(
                  text: listName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          backgroundColor: AppColors.mediumNavy,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Mark as read',
            textColor: Colors.white,
            onPressed: () async {
              await notificationService.markAsRead(notificationId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService();
    final firebaseServices = FirebaseServices();
    final currentUser = firebaseServices.currentUser;
    // To Get The Current User

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Please sign in to view notifications')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await notificationService.markAllAsRead(currentUser.uid);
                if (context.mounted) {
                  ShowSnackBar.successSnackBar(
                    context: context,
                    content: 'All notifications marked as read',
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ShowSnackBar.failureSnackBar(
                    context: context,
                    content: 'Failed to mark notifications as read',
                  );
                }
              }
            },
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        // synchronize notifications
        stream: notificationService.getNotifications(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No notifications available'),
                    backgroundColor: AppColors.orange,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Center(child: Text('No notifications')),
            );
          }

          // Filter unread notifications and sort
          final allNotifications = snapshot.data!.docs;
          final notifications =
              allNotifications
                  .where((doc) => (doc.data()['read'] ?? false) == false)
                  .toList()
                ..sort((a, b) {
                  // descending sorting
                  final aTime = a.data()['createdAt'] as Timestamp?;
                  final bTime = b.data()['createdAt'] as Timestamp?;
                  if (aTime == null && bTime == null) return 0;
                  if (aTime == null) return 1;
                  if (bTime == null) return -1;
                  return bTime.compareTo(aTime);
                });

          if (notifications.isEmpty) {
            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No notifications available'),
                    backgroundColor: AppColors.orange,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Center(child: Text('No notifications')),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final data = notification.data();
              final title = data['title'] ?? '';
              final message = data['message'] ?? '';
              final senderUserId = data['senderUserId'] as String?;
              final listId = data['listId'] as String?;

              return NotificationItem(
                notificationId: notification.id,
                title: title,
                message: message,
                isRead: false,
                senderUserId: senderUserId,
                listId: listId,
                notificationService: notificationService,
                onTap: () async {
                  if (context.mounted) {
                    await NotificationsView.showNotificationMessage(
                      context,
                      notificationService: notificationService,
                      notificationId: notification.id,
                      senderUserId: senderUserId,
                      listId: listId,
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notificationId,
    required this.title,
    required this.message,
    required this.isRead,
    this.senderUserId,
    this.listId,
    this.notificationService,
    this.onTap,
  });

  final String notificationId;
  final String title;
  final String message;
  final bool isRead;
  final String? senderUserId;
  final String? listId;
  final NotificationService? notificationService;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead
              ? Colors.white
              : AppColors.lightGrey.withValues(alpha: 0.3),
          border: Border.all(
            color: isRead
                ? AppColors.grey.withValues(alpha: 0.3)
                : AppColors.orange,
            width: isRead ? 1 : 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 12, top: 6),
                decoration: const BoxDecoration(
                  color: AppColors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(color: AppColors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),

            if (!isRead && notificationService != null)
              IconButton(
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.mediumNavy,
                ),
                tooltip: 'Mark as read',
                onPressed: () async {
                  await notificationService!.markAsRead(notificationId);
                },
              ),
          ],
        ),
      ),
    );
  }
}
