import 'package:final_project/featrues/home/presentation/views/widgets/custom_icon.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/items_list.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/list_item_info.dart';
import 'package:flutter/material.dart';

class ItemsViewBody extends StatelessWidget {
  const ItemsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIcon(
                icon: Icons.arrow_back,
                onPressed: () => Navigator.of(context).pop(),
              ),
              CustomIcon(icon: Icons.more_vert),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Grocery Shopping List',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListItemInfo(),
          ),
          Expanded(child: ItemList()),
        ],
      ),
    );
  }
}
