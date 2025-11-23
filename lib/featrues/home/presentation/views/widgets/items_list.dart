import 'package:final_project/featrues/home/data/models/item_model.dart';
import 'package:final_project/featrues/home/presentation/view_model/items_cubit/items_cubit.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_check_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key, required this.itemModel});
  final List<ItemModel> itemModel;

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    final listId = context.read<ListCubit>().currentListId!;

    return SlidableAutoCloseBehavior(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        itemCount: widget.itemModel.length,
        itemBuilder: (context, index) {
          final item = widget.itemModel[index];

          return Slidable(
            key: ValueKey(item.id),
            endActionPane: ActionPane(
              extentRatio: 0.2,
              motion: const DrawerMotion(),

              children: [
                SlidableAction(
                  onPressed: (_) {
                    context.read<ItemsCubit>().removeItem(
                      listId: listId,
                      itemId: item.id,
                      context: context,
                    );
                  },

                  // backgroundColor: Colors.red,
                  foregroundColor: Colors.black,
                  icon: Icons.delete,
                  borderRadius: BorderRadius.circular(50),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: CustomChecklistItem(
                  itemsLength: widget.itemModel.length,
                  index: index,
                  item: item,
                  onChanged: (bool? newValue) {
                    context.read<ItemsCubit>().toggleItemDone(
                      listId: listId,
                      itemId: item.id,
                      currentStatus: item.done,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
