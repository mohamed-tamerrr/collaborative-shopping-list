import 'dart:async' show StreamSubscription;
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/services/firestore_service.dart';
import 'package:final_project/core/services/notification_service.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:final_project/featrues/home/data/models/list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'list_state.dart';

class ListCubit extends Cubit<ListState> {
  ListCubit() : super(ListInitial());
  StreamSubscription? _subscription;
  String? currentListId;
  final FirebaseServices _firebaseServices = FirebaseServices();
  final NotificationService _notificationService = NotificationService();

  // list controllers
  final TextEditingController listNameController = TextEditingController();
  final TextEditingController listTagController = TextEditingController();
  final TextEditingController listNoteController = TextEditingController();

  final listKey = GlobalKey<FormState>();

  // Done
  Future<String?> createList(
    BuildContext context, {
    List<String> sharedUserIds = const [],
  }) async {
    if (listKey.currentState!.validate()) {
      try {
        final currentUser = _firebaseServices.currentUser;
        if (currentUser == null) {
          if (context.mounted) {
            ShowSnackBar.failureSnackBar(
              context: context,
              content: 'Please sign in to create a list',
            );
          }
          return null;
        }

        final trimmedName = listNameController.text.trim();
        final trimmedTag = listTagController.text.trim();

        // Combine owner and shared users
        final allMembers = [currentUser.uid, ...sharedUserIds];

        Navigator.pop(context);
        final listId = await FirestoreService().createList(
          listName: trimmedName,
          tagName: trimmedTag,
          ownerId: currentUser.uid,
          note: listNoteController.text,
          members: allMembers,
        );

        // Send notifications to shared users
        if (sharedUserIds.isNotEmpty) {
          final ownerName = currentUser.displayName ?? currentUser.email ?? 'Someone';
          for (final userId in sharedUserIds) {
            try {
              await _notificationService.createNotification(
                recipientUserId: userId,
                title: 'List Shared',
                message: '$ownerName shared "$trimmedName" list with you',
                type: 'list_shared',
                listId: listId,
                senderUserId: currentUser.uid,
              );
            } catch (e) {
              log('Error sending notification to $userId: $e');
            }
          }
        }

        clearFields();

        if (context.mounted) {
          ShowSnackBar.successSnackBar(
            context: context,
            content: 'List created successfully',
          );
        }

        return listId;
      } catch (e) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(context: context);
        }
        log(e.toString());
      }
    }
    return null;
  }

  //  Done
  Future<void> deleteList(String listId, BuildContext context) async {
    try {
      await FirestoreService().deleteList(listId);
    } catch (e) {
      if (context.mounted) {
        ShowSnackBar.failureSnackBar(context: context);
      }
      log('Error deleting list: $e');
    }
  }

  //  Done
  Future<void> renameList({
    required String listId,
    String? newName,
    String? newTag,
    String? newNote,
    required BuildContext context,
  }) async {
    try {
      await FirestoreService().renameList(newName, newTag, newNote, listId);
    } catch (e) {
      if (context.mounted) {
        ShowSnackBar.failureSnackBar(context: context);
      }
      log('Error renaming list: $e');
    }
  }

  Stream<Map<String, int>> itemsCountStream(String listId) {
    final collection = FirebaseFirestore.instance
        .collection('lists')
        .doc(listId)
        .collection('items');

    return collection.snapshots().map((snapshot) {
      int total = snapshot.docs.length;
      int completed = snapshot.docs.where((doc) => doc['done'] == true).length;

      return {'completed': completed, 'total': total};
    });
  }

  Future<void> inviteUser({
    required String listId,
    required String userId,
    required BuildContext context,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('lists').doc(listId).update({
        'members': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      if (context.mounted) {
        ShowSnackBar.failureSnackBar(context: context);
      }
      log('Error inviting user: $e');
    }
  }

  Future<void> removeUser({
    required String listId,
    required String userId,
    required BuildContext context,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('lists').doc(listId).update({
        'members': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      if (context.mounted) {
        ShowSnackBar.failureSnackBar(context: context);
      }
      log('Error removing user: $e');
    }
  }

  void listenToLists() {
    emit(ListLoading());
    _subscription = FirebaseFirestore.instance
        .collection('lists')
        .orderBy('pinned', descending: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          final lists = snapshot.docs.map((doc) {
            return ListModel.fromJson(doc);
          }).toList();
          final int listsLength = snapshot.docs.length;
          if (lists.isNotEmpty) {
            emit(ListSuccess(lists, listsLength));
          } else {
            emit(ListInitial());
          }
        });
  }

  Future<void> togglePin(String listId, bool pinned) async {
    await FirestoreService().togglePin(listId, pinned);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void clearFields() {
    listNameController.clear();
    listNoteController.clear();
    listTagController.clear();
  }

  String? validateListNameField(String? value) {
    if (value!.trim().isEmpty) {
      return 'required field';
    }
    return null;
  }
}
