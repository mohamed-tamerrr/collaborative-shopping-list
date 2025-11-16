import 'dart:async' show StreamSubscription;
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firestore_service.dart';
import 'package:final_project/featrues/home/data/models/list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'list_state.dart';

class ListCubit extends Cubit<ListState> {
  ListCubit() : super(ListInitial());
  StreamSubscription? _subscription;
  String? currentListId;

  // list controllers
  final TextEditingController listNameController =
      TextEditingController();
  final TextEditingController listTagController =
      TextEditingController();
  final TextEditingController listNoteController =
      TextEditingController();

  final listKey = GlobalKey<FormState>();

  // Done
  Future<String?> createList(BuildContext context) async {
    if (listKey.currentState!.validate()) {
      try {
        final trimmedName = listNameController.text.trim();
        final trimmedTag = listTagController.text.trim();

        final listId = await FirestoreService().createList(
          listName: trimmedName,
          tagName: trimmedTag,
          ownerId: 'userId',
          note: listNoteController.text,
        );
        clearFields();
        if (context.mounted) Navigator.pop(context);
        return listId;
      } catch (e) {
        log(e.toString());
      }
    }
    return null;
  }

  //  Done
  Future<void> deleteList(String listId) async {
    try {
      await FirestoreService().deleteList(listId);
    } catch (e) {
      log('Error deleting list: $e');
    }
  }

  //  Done
  Future<void> renameList({
    required String listId,
    String? newName,
    String? newTag,
    String? newNote,
  }) async {
    try {
      await FirestoreService().renameList(
        newName,
        newTag,
        newNote,
        listId,
      );
    } catch (e) {
      log('Error renaming list: $e');
    }
  }

  Future<void> inviteUser({
    required String listId,
    required String userId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('lists')
          .doc(listId)
          .update({
            'members': FieldValue.arrayUnion([userId]),
          });
    } catch (e) {
      log('Error inviting user: $e');
    }
  }

  Future<void> removeUser({
    required String listId,
    required String userId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('lists')
          .doc(listId)
          .update({
            'members': FieldValue.arrayRemove([userId]),
          });
    } catch (e) {
      log('Error removing user: $e');
    }
  }

  void listenToLists() {
    emit(ListLoading());
    _subscription = FirebaseFirestore.instance
        .collection('lists')
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
