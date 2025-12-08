import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/services/firestore_service.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:final_project/featrues/home/data/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsInitial());

  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController editItemNameController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseServices _firebaseServices = FirebaseServices();

  StreamSubscription? _subscription; // to check changes
  bool isEditing = false;

  void listenToItems(String listId) {
    emit(ItemsLoading());

    _subscription?.cancel();

    _subscription = FirebaseFirestore.instance
        .collection('lists')
        .doc(listId)
        .collection('items')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((snapshot) {
          final items = snapshot.docs.map((doc) {
            return ItemModel.fromJson(doc);
            // تحويل كل DocumentSnapshot إلى ItemModel باستخدام fromJson.
          }).toList();

          if (isClosed) return;

          if (items.isNotEmpty) {
            emit(ItemsSuccess(itemModel: items));
          } else {
            emit(ItemsEmpty());
          }
        });
  }

  Future<void> addItem({required String listId}) async {
    final itemName = itemNameController.text;
    if (itemName.isEmpty) return;

    final currentUser = _firebaseServices.currentUser;
    if (currentUser == null) {
      emit(ItemsFailure(errMessage: 'Unauthorized'));
      return;
    }
    final userId = currentUser.uid;

    // Verify user has access to this list
    try {
      final listDoc = await FirebaseFirestore.instance
          .collection('lists')
          .doc(listId)
          .get();

      if (!listDoc.exists) {
        emit(ItemsFailure(errMessage: 'List not found'));
        return;
      }

      final listData = listDoc.data();
      final members = List<String>.from(listData?['members'] ?? []);

      if (!members.contains(userId)) {
        emit(ItemsFailure(errMessage: 'You do not have access to this list'));
        return;
      }

      itemNameController.clear();
      // remove TextField
      await _firestoreService.addItem(
        listId: listId,
        itemName: itemName,
        addedBy: userId,
      );
    } catch (e) {
      emit(ItemsFailure(errMessage: e.toString()));
    }
  }

  Future<void> removeItem({
    required String listId,
    required String itemId,
    required BuildContext context,
  }) async {
    try {
      await FirestoreService().removeItem(listId, itemId);
    } catch (e) {
      if (context.mounted) {
        ShowSnackBar.failureSnackBar(context: context);
      }
      log('Error deleting item: $e');
    }
  }

  // to update item done(item checked or not)
  Future<void> toggleItemDone({
    required String listId,
    required String itemId,
    required bool currentStatus,
  }) async {
    await FirestoreService().updateItemDoneStatus(
      listId: listId,
      itemId: itemId,
      isDone: !currentStatus,
    );
  }

  Future<void> renameItem({
    required String listId,
    required String itemId,
    required String newName,
    required BuildContext context,
  }) async {
    try {
      await FirestoreService().renameItem(
        listId: listId,
        itemId: itemId,
        newName: newName,
      );
    } catch (e) {
      if (context.mounted) {
        ShowSnackBar.failureSnackBar(context: context);
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
