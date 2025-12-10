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
import 'package:rxdart/rxdart.dart';

part 'list_state.dart';

class ListCubit extends Cubit<ListState> {
  ListCubit() : super(ListInitial());
  StreamSubscription? _subscription;
  StreamSubscription? _userPinnedSubscription; // pinned lists
  String? currentListId;
  final FirebaseServices _firebaseServices = FirebaseServices();
  final NotificationService _notificationService = NotificationService();

  // list controllers
  final TextEditingController listNameController = TextEditingController();
  final TextEditingController listTagController = TextEditingController();
  final TextEditingController listNoteController = TextEditingController();

  final listKey =
      GlobalKey<
        FormState
      >(); // check the validity of the form before creating a list

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
          final ownerName =
              currentUser.displayName ?? currentUser.email ?? 'Someone';
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
      final currentUser = _firebaseServices.currentUser;
      if (currentUser == null) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(
            context: context,
            content: 'Please sign in to delete list',
          );
        }
        return;
      }

      // Verify user has access to this list
      final listDoc = await FirebaseFirestore.instance
          .collection('lists')
          .doc(listId)
          .get();

      if (!listDoc.exists) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(
            context: context,
            content: 'List not found',
          );
        }
        return;
      }

      final listData = listDoc.data();
      final ownerId = listData?['ownerId'] ?? '';

      // Only owner can delete the list
      if (ownerId != currentUser.uid) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(
            context: context,
            content: 'Only the owner can delete this list',
          );
        }
        return;
      }

      emit(ListLoading());
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
      final currentUser = _firebaseServices.currentUser;
      if (currentUser == null) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(
            context: context,
            content: 'Please sign in to rename list',
          );
        }
        return;
      }

      // Verify user has access to this list
      final listDoc = await FirebaseFirestore.instance
          .collection('lists')
          .doc(listId)
          .get();

      if (!listDoc.exists) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(
            context: context,
            content: 'List not found',
          );
        }
        return;
      }

      final listData = listDoc.data();
      final members = List<String>.from(listData?['members'] ?? []);

      // Only members can rename the list
      if (!members.contains(currentUser.uid)) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(
            context: context,
            content: 'You do not have access to this list',
          );
        }
        return;
      }

      await FirestoreService().renameList(newName, newTag, newNote, listId);
    } catch (e) {
      if (context.mounted) {
        ShowSnackBar.failureSnackBar(context: context);
      }
      log('Error renaming list: $e');
    }
  }

  Stream<Map<String, int>> itemsCountStream(String listId) {
    final currentUser = _firebaseServices.currentUser;
    if (currentUser == null) {
      return Stream.value({'completed': 0, 'total': 0});
    }

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
      final currentUser = _firebaseServices.currentUser;
      if (currentUser == null) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(
            context: context,
            content: 'Please sign in to invite users',
          );
        }
        return;
      }

      // Verify user has access to this list and is the owner
      final listDoc = await FirebaseFirestore.instance
          .collection('lists')
          .doc(listId)
          .get();

      if (!listDoc.exists) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(
            context: context,
            content: 'List not found',
          );
        }
        return;
      }

      final listData = listDoc.data();
      final ownerId = listData?['ownerId'] ?? '';
      final currentMembers = List<String>.from(listData?['members'] ?? []);

      // Only owner can invite users
      if (ownerId != currentUser.uid) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(
            context: context,
            content: 'Only the owner can add members to this list',
          );
        }
        return;
      }

      // Check if user is already a member
      if (currentMembers.contains(userId)) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(
            context: context,
            content: 'User is already a member of this list',
          );
        }
        return;
      }

      // Add user to list
      await FirebaseFirestore.instance.collection('lists').doc(listId).update({
        'members': FieldValue.arrayUnion([userId]),
      });

      // Send notification to the invited user
      final listName = listData?['name'] ?? 'a list';
      final ownerName =
          currentUser.displayName ?? currentUser.email ?? 'Someone';
      try {
        await _notificationService.createNotification(
          recipientUserId: userId,
          title: 'List Shared',
          message: '$ownerName added you to "$listName" list',
          type: 'list_shared',
          listId: listId,
          senderUserId: currentUser.uid,
        );
      } catch (e) {
        log('Error sending notification to $userId: $e');
      }

      if (context.mounted) {
        ShowSnackBar.successSnackBar(
          context: context,
          content: 'User added successfully',
        );
      }
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
      final currentUser = _firebaseServices.currentUser;
      if (currentUser == null) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(
            context: context,
            content: 'Please sign in to remove users',
          );
        }
        return;
      }

      // Verify user has access to this list and is the owner
      final listDoc = await FirebaseFirestore.instance
          .collection('lists')
          .doc(listId)
          .get();

      if (!listDoc.exists) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(
            context: context,
            content: 'List not found',
          );
        }
        return;
      }

      final listData = listDoc.data();
      final ownerId = listData?['ownerId'] ?? '';
      final currentMembers = List<String>.from(listData?['members'] ?? []);

      // Only owner can remove users
      if (ownerId != currentUser.uid) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(
            context: context,
            content: 'Only the owner can remove members from this list',
          );
        }
        return;
      }

      // Prevent removing the owner
      if (userId == ownerId) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(
            context: context,
            content: 'Cannot remove the owner from the list',
          );
        }
        return;
      }

      // Check if user is actually a member
      if (!currentMembers.contains(userId)) {
        if (context.mounted) {
          ShowSnackBar.failureSnackBar(
            context: context,
            content: 'User is not a member of this list',
          );
        }
        return;
      }

      // Remove user from list
      await FirebaseFirestore.instance.collection('lists').doc(listId).update({
        'members': FieldValue.arrayRemove([userId]),
      });

      if (context.mounted) {
        ShowSnackBar.successSnackBar(
          context: context,
          content: 'User removed successfully',
        );
      }
    } catch (e) {
      if (context.mounted) {
        ShowSnackBar.failureSnackBar(context: context);
      }
      log('Error removing user: $e');
    }
  }

  void listenToLists() {
    _subscription?.cancel(); // Cancel previous subscription if any
    emit(ListLoading());

    final currentUser = _firebaseServices.currentUser;
    if (currentUser == null) {
      emit(ListInitial());
      return;
    }

    // Listen to lists where user is a member OR the owner
    final listsStream = FirebaseFirestore.instance
        .collection('lists')
        .where(
          Filter.or(
            Filter('members', arrayContains: currentUser.uid),
            Filter('ownerId', isEqualTo: currentUser.uid),
          ),
        )
        .snapshots();

    final userPinnedStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .snapshots()
        .map((snapshot) {
          final data = snapshot.data();
          if (data == null || !data.containsKey('pinnedLists')) {
            return <String>[];
          }
          return List<String>.from(data['pinnedLists'] ?? []);
        });

    // Combine both streams using CombineLatestStream
    _subscription =
        CombineLatestStream.combine2(listsStream, userPinnedStream, (
          QuerySnapshot<Map<String, dynamic>> listsSnapshot,
          List<String> pinnedLists,
        ) {
          // Convert to ListModel with user-specific pinned status
          final lists =
              listsSnapshot.docs.map((doc) {
                final listData = doc.data();
                final isPinned = pinnedLists.contains(doc.id);

                return ListModel(
                  id: doc.id,
                  name: listData['name'] ?? '',
                  ownerId: listData['ownerId'] ?? '',
                  members: List<String>.from(listData['members'] ?? []),
                  note: listData['note'],
                  tag: listData['tag'] ?? '',
                  createdAt: (listData['createdAt'] as Timestamp?)?.toDate(),
                  pinned: isPinned,
                );
              }).toList()..sort((a, b) {
                // Sort by pinned first, then by createdAt
                if (a.pinned != b.pinned) {
                  return b.pinned ? 1 : -1; // Pinned lists first
                }
                // Then sort by createdAt (newest first)
                if (a.createdAt == null && b.createdAt == null) return 0;
                if (a.createdAt == null) return 1;
                if (b.createdAt == null) return -1;
                return b.createdAt!.compareTo(a.createdAt!);
              });

          return lists;
        }).listen((lists) {
          final int listsLength = lists.length;
          // Always emit success even if empty, so UI can show "No lists" instead of stuck loading
          if (lists.isNotEmpty) {
            emit(ListSuccess(lists, listsLength));
          } else {
            // If we really want to distinguish no lists from initial, we can emit success with empty list.
            // But existing UI uses NoListPage for state != ListSuccess? No, explicit check.
            // Original code emitted ListInitial if empty... let's stick to ListSuccess with empty list if that's better, or ListInitial.
            // Original: if (lists.isNotEmpty) emit(ListSuccess) else emit(ListInitial).
            // Let's keep original logic for now to minimize side effects,
            // but 'ListInitial' might show loading or nothing depending on view.
            if (lists.isNotEmpty) {
              emit(ListSuccess(lists, listsLength));
            } else {
              emit(
                ListSuccess([], 0),
              ); // Changed to ListSuccess([]) to assert "Loaded but empty".
            }
          }
        });
  }

  Future<void> togglePin(String listId, bool pinned) async {
    final currentUser = _firebaseServices.currentUser;
    if (currentUser == null) return;

    await FirestoreService().togglePin(
      listId: listId,
      userId: currentUser.uid,
      isCurrentlyPinned: pinned,
    );
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
