import 'package:final_project/featrues/home/data/models/list_model.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/items_view_body.dart';
import 'package:flutter/material.dart';

class ItemsView extends StatelessWidget {
  const ItemsView({super.key, required this.listModel});
  final ListModel listModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: ItemsViewBody(listModel: listModel)),
    );
  }
}
