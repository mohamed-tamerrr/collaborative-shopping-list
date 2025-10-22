import 'dart:async' show StreamSubscription;
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'list_state.dart';

class ListCubit extends Cubit<ListState> {
  ListCubit() : super(ListInitial());
  StreamSubscription? _subscription;

  // list controllers
  final TextEditingController listNameController = TextEditingController();
  final TextEditingController listNoteController = TextEditingController();

  final listKey = GlobalKey<FormState>();

  Future<String?> createList(BuildContext context) async {
    if (listKey.currentState!.validate()) {
      try {
        final trimmedName = listNameController.text.trim();

        final listId = await FirestoreService().createList(
          listName: trimmedName,
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

  Future<void> deleteList(String listId) async {
    try {
      await FirestoreService().deleteList(listId);
    } catch (e) {
      log('Error deleting list: $e');
    }
  }

  Future<void> renameList({
    required String listId,
    String? newName,
    String? newNote,
  }) async {
    try {
      await FirestoreService().renameList(newName, newNote, listId);
    } catch (e) {
      log('Error renaming list: $e');
    }
  }

  Future<void> inviteUser({
    required String listId,
    required String userId,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('lists').doc(listId).update({
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
      await FirebaseFirestore.instance.collection('lists').doc(listId).update({
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
        .snapshots()
        .listen((snapshot) {
          final lists = snapshot.docs.map((e) => e.data()).toList();
          if (lists.isNotEmpty) {
            emit(ListSuccess(lists));
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
  }

  String? validateListNameField(String? value) {
    if (value!.trim().isEmpty) {
      return 'List name is required';
    }
    return null;
  }
}
