import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firestore_service.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:final_project/featrues/home/data/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsInitial());

  final TextEditingController itemNameController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription? _subscription;

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
          }).toList();

          if (isClosed) return;

          if (items.isNotEmpty) {
            emit(ItemsSuccess(itemModel: items));
          } else {
            emit(ItemsEmpty());
          }
        });
  }

  Future<void> addItem({required String listId, required String userId}) async {
    final itemName = itemNameController.text;
    if (itemName.isEmpty) return;

    try {
      itemNameController.clear();
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
      emit(ItemsLoading());

      await FirestoreService().renameItem(
        listId: listId,
        itemId: itemId,
        newName: newName,
      );
      if (context.mounted) {
        ShowSnackBar.successSnackBar(
          context: context,
          content: 'item renamed successfully',
        );
      }
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
