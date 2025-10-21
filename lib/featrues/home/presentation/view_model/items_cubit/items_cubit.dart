import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firestore_service.dart';
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
            return {'id': doc.id, ...doc.data()};
          }).toList();
        });
  }

  Future<void> addItem({required String listId, required String userId}) async {
    final itemName = itemNameController.text;
    if (itemName.isEmpty) return;

    try {
      await _firestoreService.addItem(
        listId: listId,
        itemName: itemName,
        addedBy: userId,
      );
      itemNameController.clear();
    } catch (e) {
      emit(ItemsFailure(errMessage: e.toString()));
    }
  }

  Future<void> removeItem({
    required String listId,
    required String itemId,
  }) async {
    try {
      await FirestoreService().removeItem(listId, itemId);
    } catch (e) {
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
}
