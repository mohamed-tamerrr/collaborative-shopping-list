import 'package:final_project/featrues/home/data/models/list_model.dart';
import 'package:final_project/featrues/home/presentation/view_model/items_cubit/items_cubit.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/add_item_container.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_icon.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/items_list.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/list_item_info.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<ItemsCubit, ItemsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// top bar
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  CustomIcon(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    currentName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'rename') {
                        final TextEditingController
                        renameController =
                            TextEditingController();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Rename List'),
                              content: TextField(
                                controller: renameController,
                                decoration:
                                    const InputDecoration(
                                      labelText: 'New name',
                                      border:
                                          OutlineInputBorder(),
                                    ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final newName =
                                        renameController.text
                                            .trim();
                                    if (newName.isNotEmpty) {
                                      await context
                                          .read<ListCubit>()
                                          .renameList(
                                            listId: widget
                                                .listModel
                                                .id,
                                            newName: newName,
                                          );
                                      setState(() {
                                        currentName = newName;
                                      });
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'List renamed successfully',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (value == 'delete') {
                        context.read<ListCubit>().deleteList(
                          widget.listModel.id,
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text('Delete selected'),
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'rename',
                        child: Text('Rename'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// LIST STATES
              state is ItemsLoading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : state is ItemsSuccess
                  ? Expanded(
                      child: Column(
                        children: [
                          /// Calculate done items here
                          SizedBox(
                            height: 55,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                              child: ListItemInfo(
                                tagName: widget.tagName,
                                itemslength:
                                    state.itemModel.length,
                                doneItemslength: state.itemModel
                                    .where((item) => item.done)
                                    .length,
                              ),
                            ),
                          ),

                          Expanded(
                            child: ItemList(
                              itemModel: state.itemModel,
                            ),
                          ),
                        ],
                      ),
                    )
                  : state is ItemsFailure
                  ? const Center(child: Text('Error'))
                  : const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: AddItemContainer(),
                    ),
            ],
          );
        },
      ),
    );
  }
}
