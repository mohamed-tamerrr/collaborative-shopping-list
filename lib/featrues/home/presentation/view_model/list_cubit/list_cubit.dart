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
  final TextEditingController listNameController =
      TextEditingController();
  final TextEditingController listNoteController =
      TextEditingController();

  // items controller
  final TextEditingController itemNameController =
      TextEditingController();

  createList() async {
    try {
      if (listNameController.text != '') {
        await FirestoreService().createList(
          listName: listNameController.text,
          ownerId: 'userId',
          note: listNoteController.text,
        );
      } else {
        log('list name required');
      }
      clearFields();
    } catch (e) {
      log(e.toString());
    }
  }

  void listenToLists() {
    emit(ListLoading());
    _subscription = FirebaseFirestore.instance
        .collection('lists')
        .snapshots()
        .listen((snapshot) {
          final lists = snapshot.docs
              .map((e) => e.data())
              .toList();
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

  // todo: move it to ItemsCubit
  addItem() async {
    await FirestoreService().addItem(
      listId: 'listId',
      itemName: itemNameController.text,
      addedBy: 'userId',
    );
  }

  void clearFields() {
    listNameController.clear();
    listNoteController.clear();
  }
}
