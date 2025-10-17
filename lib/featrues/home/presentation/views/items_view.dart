import 'package:final_project/featrues/home/presentation/views/widgets/items_view_body.dart';
import 'package:flutter/material.dart';

class ItemsView extends StatelessWidget {
  const ItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: ItemsViewBody()));
  }
}
