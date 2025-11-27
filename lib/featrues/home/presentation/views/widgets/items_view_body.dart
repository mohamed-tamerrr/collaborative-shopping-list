import 'package:final_project/featrues/home/data/models/list_model.dart';
import 'package:final_project/featrues/home/presentation/view_model/items_cubit/items_cubit.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/items_view_appbar.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/items_view_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsViewBody extends StatefulWidget {
  const ItemsViewBody({
    super.key,
    required this.listModel,
    required this.tagName,
  });

  final ListModel listModel;
  final String tagName;

  @override
  State<ItemsViewBody> createState() => _ItemsViewBodyState();
}

class _ItemsViewBodyState extends State<ItemsViewBody> {
  late String currentName;

  @override
  void initState() {
    super.initState();
    context.read<ItemsCubit>().listenToItems(
      context.read<ListCubit>().currentListId!,
    );
    currentName = widget.listModel.name;
  }

  void updateName(String name) {
    setState(() {
      currentName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            ItemsViewAppBar(
              currentName: currentName,
              listModel: widget.listModel,
              onRename: updateName,
            ),
            const SizedBox(height: 8),
            Expanded(child: ItemsViewContent(tagName: widget.tagName)),
          ],
        ),
      ),
    );
  }
}
