import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/featrues/home/data/models/list_model.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/items_view.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/group_avatar.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/list_item_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.listModel, required this.listId});

  final ListModel listModel;
  final String listId;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(listId),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) async {
              // Show confirmation dialog
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Column(
                    children: [
                      Text(
                        'Are you sure?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Do you really want to delete this list? You will not be able to undo this action',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );

              if (shouldDelete == true && context.mounted) {
                await context.read<ListCubit>().deleteList(listId, context);
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          context.read<ListCubit>().currentListId = listId;

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ItemsView(
                listModel: listModel,
                listId: listId,
                tagName: listModel.tag,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xffEAECF0), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 24,
              right: 10,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        listModel.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () async {
                        await context.read<ListCubit>().togglePin(
                          listId,
                          listModel.pinned,
                        );
                      },
                      icon: Icon(
                        listModel.pinned
                            ? Icons.push_pin
                            : Icons.push_pin_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _getMembersData(listModel.members),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 35,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    final membersData = snapshot.data ?? [];
                    // Fallback if empty and list is not empty handled by passing what we have.
                    // Actually, if fetch fails, we return empty list, so GroupAvatars shows nothing, which is cleaner than showing broken loaders.

                    return GroupAvatars(membersData: membersData);
                  },
                ),

                const SizedBox(height: 8),

                StreamBuilder(
                  stream: context.read<ListCubit>().itemsCountStream(listId),
                  builder: (context, snapshot) {
                    int completed = 0;
                    int total = 0;

                    if (snapshot.hasData) {
                      completed = snapshot.data!['completed']!;
                      total = snapshot.data!['total']!;
                    }

                    return ListItemInfo(
                      itemslength: total,
                      doneItemslength: completed,
                      tagName: listModel.tag,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getMembersData(
    List<String> memberIds,
  ) async {
    if (memberIds.isEmpty) {
      return [];
    }

    final firestore = FirebaseFirestore.instance;
    final membersData = <Map<String, dynamic>>[];

    // Get all member documents
    try {
      final docs = await Future.wait(
        memberIds.map((memberId) async {
          try {
            return await firestore.collection('users').doc(memberId).get();
          } catch (e) {
            return null;
          }
        }),
      );

      for (var doc in docs) {
        if (doc != null && doc.exists) {
          final data = doc.data();
          membersData.add({
            'photoUrl': data?['photoUrl'] as String?,
            'name': data?['name'] as String? ?? '',
            'email': data?['email'] as String?,
          });
        }
      }

      return membersData;
    } catch (e) {
      return [];
    }
  }
}
