import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/featrues/home/data/models/item_model.dart';
import 'package:final_project/featrues/home/presentation/view_model/items_cubit/items_cubit.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomChecklistItem extends StatefulWidget {
  const CustomChecklistItem({
    super.key,
    required this.item,
    required this.onChanged,
    required this.index,
    required this.itemsLength,
  });

  final ItemModel item;
  final ValueChanged<bool?> onChanged;
  final int index;
  final int itemsLength;

  @override
  State<CustomChecklistItem> createState() => _CustomChecklistItemState();
}

class _CustomChecklistItemState extends State<CustomChecklistItem> {
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    final bool isChecked = widget.item.done;
    final Color borderColor = isChecked ? AppColors.mediumNavy : Colors.grey;
    final Color backgroundColor = isChecked
        ? AppColors.lightGrey.withValues(alpha: 0.5)
        : Colors.white;

    return GestureDetector(
      onLongPress: () {
        if (!context.read<ItemsCubit>().isEditing) {
          context.read<ItemsCubit>().editItemNameController.text =
              widget.item.name;
          isEnabled = false;
          setState(() {
            context.read<ItemsCubit>().isEditing = !context
                .read<ItemsCubit>()
                .isEditing;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Center(
          child: IntrinsicHeight(
            child: CheckboxListTile(
              enabled: isEnabled,
              title: context.read<ItemsCubit>().isEditing
                  ? CustomTextField(
                      item: widget.item,
                      onTap: () {
                        context.read<ItemsCubit>().isEditing = false;
                        isEnabled = true;
                        context.read<ItemsCubit>().renameItem(
                          listId: context.read<ListCubit>().currentListId!,
                          itemId: widget.item.id,
                          newName:
                              context
                                      .read<ItemsCubit>()
                                      .editItemNameController
                                      .text
                                      .trim() ==
                                  ''
                              ? widget.item.name
                              : context
                                    .read<ItemsCubit>()
                                    .editItemNameController
                                    .text
                                    .trim(),
                          context: context,
                        );
                        setState(() {});
                      },
                    )
                  : Text(
                      widget.item.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: isChecked ? AppColors.mediumNavy : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
              value: isChecked,
              onChanged: widget.onChanged,
              activeColor: AppColors.mediumNavy,
              checkColor: Colors.white,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.item, this.onTap});
  final ItemModel item;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: context.read<ItemsCubit>().editItemNameController,
      decoration: InputDecoration(
        suffixIconConstraints: BoxConstraints(maxHeight: double.infinity),
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: Icon(Icons.check, color: Colors.green, size: 22),
        ),
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
      ),
    );
  }
}
