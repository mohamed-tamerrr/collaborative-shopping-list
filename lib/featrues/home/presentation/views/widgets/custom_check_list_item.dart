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
  TextEditingController editItemNameController = TextEditingController();
  bool? isEditingThisItem;

  @override
  Widget build(BuildContext context) {
    final bool isChecked = widget.item.done;
    final Color borderColor = isChecked ? AppColors.mediumNavy : Colors.grey;
    final Color backgroundColor = isChecked
        ? AppColors.lightGrey.withValues(alpha: 0.5)
        : Colors.white;

    return GestureDetector(
      onLongPress: () {
        BlocProvider.of<ItemsCubit>(context).editingItemId = widget.item.id;
        editItemNameController.text = widget.item.name;
        isEditingThisItem =
            BlocProvider.of<ItemsCubit>(context).editingItemId ==
            widget.item.name;
        setState(() {});
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
              title: isEditingThisItem != null || isEditingThisItem == true
                  ? CustomTextField(
                      controller: editItemNameController,
                      item: widget.item,
                      onTap: () {
                        isEditingThisItem = null;
                        context.read<ItemsCubit>().renameItem(
                          listId: context.read<ListCubit>().currentListId!,
                          itemId: widget.item.id,
                          newName: editItemNameController.text.trim() == ''
                              ? widget.item.name
                              : editItemNameController.text.trim(),
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
                        decorationColor: AppColors.navyBlue,
                        decoration: isChecked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationThickness: 2,
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
  const CustomTextField({
    super.key,
    required this.item,
    this.onTap,
    required this.controller,
  });
  final ItemModel item;
  final void Function()? onTap;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(fontSize: 16),
      autofocus: true,
      controller: controller,
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
