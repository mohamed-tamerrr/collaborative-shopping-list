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
    return _firestore
        .collection('notifications')
        .where('recipientUserId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get unread notifications count
  Stream<int> getUnreadCount(String userId) {
    return _firestore
        .collection('notifications')
        .where('recipientUserId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
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

