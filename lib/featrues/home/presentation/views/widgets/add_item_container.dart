import 'package:final_project/featrues/home/presentation/view_model/items_cubit/items_cubit.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddItemContainer extends StatelessWidget {
  const AddItemContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey, width: 1.5),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              if (context
                  .read<ItemsCubit>()
                  .itemNameController
                  .text
                  .trim()
                  .isNotEmpty) {
                String? currentListId = context
                    .read<ListCubit>()
                    .currentListId;
                await context.read<ItemsCubit>().addItem(
                  listId: currentListId!,
                  userId: 'nour mowafey',
                );
              }
            },
            icon: Icon(Icons.add),
            padding: EdgeInsets.zero,
          ),
          Expanded(
            child: TextField(
              controller: context
                  .read<ItemsCubit>()
                  .itemNameController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                hintText: 'list item',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
