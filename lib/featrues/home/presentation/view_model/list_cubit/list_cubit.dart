import 'dart:developer';

import 'package:final_project/core/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'list_state.dart';

class ListCubit extends Cubit<ListState> {
  ListCubit() : super(ListInitial());

  // list controllers
  final TextEditingController listNameController = TextEditingController();
  final TextEditingController listNoteController = TextEditingController();

  // items controllers
  final TextEditingController itemNameController = TextEditingController();

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
