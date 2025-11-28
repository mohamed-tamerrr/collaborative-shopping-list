import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a notification
  Future<void> createNotification({
    required String recipientUserId,
    required String title,
    required String message,
    required String type, // 'list_shared', 'item_added', etc.
    String? listId,
    String? senderUserId,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'recipientUserId': recipientUserId,
        'title': title,
        'message': message,
        'type': type,
        'listId': listId,
        'senderUserId': senderUserId ?? _auth.currentUser?.uid,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  // Get notifications for current user
  Stream<QuerySnapshot<Map<String, dynamic>>> getNotifications(String userId) {
    // Remove orderBy to avoid index requirement - we'll sort in memory
    return _firestore
        .collection('notifications')
        .where('recipientUserId', isEqualTo: userId)
        .snapshots();
  }

  // Get unread notifications only
  // Note: We use getNotifications and filter in the UI to avoid index requirement
  Stream<QuerySnapshot<Map<String, dynamic>>> getUnreadNotifications(
    String userId,
  ) {
    // Just return all notifications - filtering will be done in UI
    // This avoids the need for a composite index
    return getNotifications(userId);
  }

  // Get unread notifications count
  Stream<int> getUnreadCount(String userId) {
    // Get all notifications for user, then filter in memory
    return _firestore
        .collection('notifications')
        .where('recipientUserId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      // Count unread notifications
      return snapshot.docs
          .where((doc) => (doc.data()['read'] ?? false) == false)
          .length;
    });
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'read': true,
    });
  }

  // Mark all notifications as read
  Future<void> markAllAsRead(String userId) async {
    final batch = _firestore.batch();
    final notifications = await _firestore
        .collection('notifications')
        .where('recipientUserId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .get();

    for (var doc in notifications.docs) {
      batch.update(doc.reference, {'read': true});
    }

    await batch.commit();
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).delete();
  }
}


