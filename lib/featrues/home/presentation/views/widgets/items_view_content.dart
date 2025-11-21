import 'package:final_project/featrues/home/presentation/view_model/items_cubit/items_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/add_item_container.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/items_list.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/list_item_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsViewContent extends StatelessWidget {
  final String tagName;

  const ItemsViewContent({super.key, required this.tagName});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsCubit, ItemsState>(
      builder: (context, state) {
        if (state is ItemsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ItemsFailure) {
          return const Center(child: Text("Error"));
        }

        if (state is ItemsSuccess) {
          final items = state.itemModel;
          final done = items.where((e) => e.done).length;

          return Column(
            children: [
              SizedBox(
                height: 55,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  child: ListItemInfo(
                    tagName: tagName,
                    itemslength: items.length,
                    doneItemslength: done,
                  ),
                ),
              ),
              if (items.isEmpty)
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 8,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 400,
                        ),
                        child: const AddItemContainer(),
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ItemList(itemModel: items),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 400,
                          ),
                          child: const AddItemContainer(),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }

        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: const AddItemContainer(),
            ),
          ),
        );
      },
    );
  }
}
