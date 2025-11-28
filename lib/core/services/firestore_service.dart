import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // create list(collection)
  Future<String> createList({
    required String listName,
    required String tagName,
    required String ownerId,
    String? note,
    List<String>? members,
  }) async {
    final doc = await _db.collection('lists').add({
      'name': listName,
      'tag': tagName,
      'ownerId': ownerId,
      'members': members ?? [ownerId],
      'createdAt': FieldValue.serverTimestamp(),
      'note': note,
    });
    return doc.id;
  }

  // delete list
  Future<void> deleteList(String listId) async {
    // to delete all items inside the list
    final itemsSnapshot = await _db
        .collection('lists')
        .doc(listId)
        .collection('items')
        .get();
    for (final doc in itemsSnapshot.docs) {
      await doc.reference.delete();
    }
    // delete the list document itself
    await _db.collection('lists').doc(listId).delete();
  }

  // update list name or list note or list tag
  Future<void> renameList(
    String? newName,
    String? newTag,
    String? newNote,
    String listId,
  ) async {
    final updates = <String, dynamic>{};

    if (newName != null && newName.isNotEmpty) updates['name'] = newName;
    if (newNote != null && newNote.isNotEmpty) updates['note'] = newNote;
    if (newTag != null && newTag.isNotEmpty) updates['tag'] = newTag;

    if (updates.isNotEmpty) {
      await _db.collection('lists').doc(listId).update(updates);
    } else {
      log('No updates provided');
    }
  }

  // Toggle pin for a specific user (user-specific pinning)
  Future<void> togglePin({
    required String listId,
    required String userId,
    required bool isCurrentlyPinned,
  }) async {
    final userRef = _db.collection('users').doc(userId);

    if (isCurrentlyPinned) {
      // Remove from pinned lists
      await userRef.update({
        'pinnedLists': FieldValue.arrayRemove([listId]),
      });
    } else {
      // Add to pinned lists
      await userRef.update({
        'pinnedLists': FieldValue.arrayUnion([listId]),
      });
    }
  }

  // Get user's pinned lists
  Future<List<String>> getUserPinnedLists(String userId) async {
    try {
      final userDoc = await _db.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        return List<String>.from(data?['pinnedLists'] ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // add item(subcollection of the listId)
  Future<void> addItem({
    required String listId,
    required String itemName,
    required String addedBy,
  }) async {
    await _db.collection('lists').doc(listId).collection('items').add({
      'name': itemName,
      'done': false,
      'addedBy': addedBy,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeItem(String listId, String itemId) async {
    await _db
        .collection('lists')
        .doc(listId)
        .collection('items')
        .doc(itemId)
        .delete();
  }

  // to update item done(item checked or not)
  Future<void> updateItemDoneStatus({
    required String listId,
    required String itemId,
    required bool isDone,
  }) async {
    try {
      await _db
          .collection('lists')
          .doc(listId)
          .collection('items')
          .doc(itemId)
          .update({'done': isDone});

      log('Item $itemId done status updated to $isDone');
    } catch (e) {
      log('Error updating done status: $e');
    }
  }

  Future<void> renameItem({
    required String listId,
    required String itemId,
    required String newName,
  }) async {
    await _db
        .collection('lists')
        .doc(listId)
        .collection('items')
        .doc(itemId)
        .update({'name': newName});
  }
}

