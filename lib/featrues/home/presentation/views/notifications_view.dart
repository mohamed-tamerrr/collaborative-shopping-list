import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/services/notification_service.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  static Future<void> showNotificationDetailsDialog(
    BuildContext context, {
    String? senderUserId,
    String? listId,
    required String message,
  }) async {
    final firebaseServices = FirebaseServices();
    String senderEmail = 'Unknown';
    String listName = 'Unknown List';

    // Get sender email
    if (senderUserId != null) {
      try {
        final senderDoc = await firebaseServices.getUserByUid(senderUserId);
        if (senderDoc.exists) {
          final senderData = senderDoc.data();
          senderEmail = senderData?['email'] ?? 'Unknown';
        }
      } catch (e) {
        // Handle error
      }
    }

    // Get list name
    if (listId != null) {
      try {
        final listDoc = await FirebaseFirestore.instance
            .collection('lists')
            .doc(listId)
            .get();
        if (listDoc.exists) {
          final listData = listDoc.data();
          listName = listData?['name'] ?? 'Unknown List';
        }
      } catch (e) {
        // Handle error
      }
    }

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Notification Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: [
                    const TextSpan(text: 'الايميل '),
                    TextSpan(
                      text: senderEmail,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const TextSpan(text: ' بيدعك ل الليست اللي اسمها '),
                    TextSpan(
                      text: listName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService();
    final firebaseServices = FirebaseServices();
    final currentUser = firebaseServices.currentUser;

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
                    content: 'Failed to mark as read',
                  );
                }
              }
            },
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: notificationService.getNotifications(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No notifications'),
            );
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final data = notification.data();
              final isRead = data['read'] ?? false;
              final title = data['title'] ?? '';
              final message = data['message'] ?? '';
              final senderUserId = data['senderUserId'] as String?;
              final listId = data['listId'] as String?;

              return NotificationItem(
                notificationId: notification.id,
                title: title,
                message: message,
                isRead: isRead,
                senderUserId: senderUserId,
                listId: listId,
                onTap: () async {
                  // Mark as read
                  if (!isRead) {
                    await notificationService.markAsRead(notification.id);
                  }

                  // Show notification details dialog
                  if (context.mounted) {
                    await NotificationsView.showNotificationDetailsDialog(
                      context,
                      senderUserId: senderUserId,
                      listId: listId,
                      message: message,
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
    this.onTap,
  });

  final String notificationId;
  final String title;
  final String message;
  final bool isRead;
  final String? senderUserId;
  final String? listId;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : AppColors.lightGrey.withValues(alpha: 0.3),
          border: Border.all(
            color: isRead ? AppColors.grey.withValues(alpha: 0.3) : AppColors.primaryColor,
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
                  color: AppColors.primaryColor,
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
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

