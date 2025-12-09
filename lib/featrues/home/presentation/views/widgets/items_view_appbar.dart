import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_button.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_icon.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/manage_members_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ItemsViewAppBar extends StatelessWidget {
  final String currentName;
  final Function(String) onRename;
  final dynamic listModel;
  final FirebaseServices _firebaseServices = FirebaseServices();

  ItemsViewAppBar({
    super.key,
    required this.currentName,
    required this.listModel,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = _firebaseServices.currentUser;
    final isOwner = currentUser != null && listModel.ownerId == currentUser.uid;

    return Row(
      children: [
        CustomIcon(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            currentName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'rename') {
              _renameList(context);
            } else if (value == 'delete') {
              await _showDeleteDialog(context);
            } else if (value == 'manage_members') {
              _showManageMembersDialog(context);
            }
          },
          itemBuilder: (context) {
            final items = <PopupMenuItem<String>>[
              const PopupMenuItem(value: 'rename', child: Text('Rename')),
            ];

            if (isOwner) {
              items.add(
                const PopupMenuItem(
                  value: 'manage_members',
                  child: Text('Manage Members'),
                ),
              );
            }

            items.add(
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            );

            return items;
          },
        ),
      ],
    );
  }

  void _renameList(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rename List"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "New name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                await context.read<ListCubit>().renameList(
                  listId: listModel.id,
                  newName: newName,
                  context: context,
                );
                onRename(newName);

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('List renamed successfully')),
                  );
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
                style: TextStyle(fontSize: 16, color: AppColors.grey),
              ),
            ],
          ),
          actions: [
            CustomButton(
              title: 'No',
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 6),
            CustomButton(
              title: 'Yes',
              onPressed: () async {
                context.read<ListCubit>().deleteList(
                  listModel.id,
                  context,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('List Has Been Deleted'),
                    backgroundColor: AppColors.orange,
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showManageMembersDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context) {
        return ManageMembersDialog(
          listId: listModel.id,
          listName: listModel.name,
          currentMembers: List<String>.from(listModel.members),
          ownerId: listModel.ownerId,
        );
      },
    );
  }
}
