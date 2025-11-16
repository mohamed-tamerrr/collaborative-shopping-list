import 'package:final_project/featrues/home/data/models/item_model.dart';
import 'package:final_project/featrues/home/presentation/view_model/items_cubit/items_cubit.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_check_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key, required this.itemModel});
  final List<ItemModel> itemModel;
  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.itemModel.length,
        itemBuilder: (context, index) {
          return CustomChecklistItem(
            itemsLength: widget.itemModel.length,
            index: index,
            item: widget.itemModel[index],
            onChanged: (bool? newValue) {
              context.read<ItemsCubit>().toggleItemDone(
                listId: context.read<ListCubit>().currentListId!,
                itemId: widget.itemModel[index].id,
                currentStatus: widget.itemModel[index].done,
              );
            },
          );
        },
      ),
    );
  }
}
