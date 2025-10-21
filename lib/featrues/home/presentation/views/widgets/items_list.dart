import 'package:final_project/featrues/home/data/models/item_model.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_check_list_item.dart';
import 'package:flutter/material.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final List<ItemModel> items = [
    ItemModel('Milk'),
    ItemModel('Eggs'),
    ItemModel('Butter'),
    ItemModel('Bread'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return CustomChecklistItem(
            itemsLength: items.length,
            index: index,
            item: items[index],
            onChanged: (bool? newValue) {
              setState(() {
                items[index].isChecked = newValue!;
              });
            },
          );
        },
      ),
    );
  }
}
