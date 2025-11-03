import 'package:final_project/featrues/home/data/models/item_model.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/add_item_container.dart';
import 'package:flutter/material.dart';

class CustomChecklistItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final bool isChecked = item.done;
    final Color borderColor = isChecked ? Colors.deepPurple : Colors.grey;
    final Color backgroundColor = isChecked
        ? Colors.deepPurple.shade50
        : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          margin: const EdgeInsets.only(bottom: 12.0),
          child: CheckboxListTile(
            title: Text(
              item.name,
              style: TextStyle(
                fontSize: 16,
                color: isChecked ? Colors.deepPurple : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            value: isChecked,
            onChanged: onChanged,
            activeColor: Colors.deepPurple,
            checkColor: Colors.white,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        index == itemsLength - 1 ? AddItemContainer() : SizedBox(),
      ],
    );
  }
}
