import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsViewAppBar extends StatelessWidget {
  final String currentName;
  final Function(String) onRename;
  final dynamic listModel;

  const ItemsViewAppBar({
    super.key,
    required this.currentName,
    required this.listModel,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomIcon(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
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
              _renameList(context);
            } else if (value == 'delete') {
              context.read<ListCubit>().deleteList(listModel.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete selected')),
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
                );
                onRename(newName);

                if (context.mounted) Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('List renamed successfully'),
                  ),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
