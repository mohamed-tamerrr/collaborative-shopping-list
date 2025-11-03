import 'package:final_project/featrues/home/data/models/list_model.dart';
import 'package:final_project/featrues/home/presentation/view_model/items_cubit/items_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/items_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsView extends StatelessWidget {
  const ItemsView({super.key, required this.listModel, required this.listId, required this.tagName});
  final ListModel listModel;
  final String listId;
  final String tagName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemsCubit(),
      child: Scaffold(
        body: SafeArea(child: ItemsViewBody(listModel: listModel, tagName: tagName,)),
      ),
    );
  }
}
