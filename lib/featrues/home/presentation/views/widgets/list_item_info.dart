import 'package:final_project/featrues/home/data/models/list_model.dart';
import 'package:flutter/material.dart';

class ListItemInfo extends StatelessWidget {
  const ListItemInfo({super.key, this.listModel});
  final ListModel? listModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.list),
        SizedBox(width: 4),
        Text('List 1/7 Completed'),
        SizedBox(width: 56),
        Icon(Icons.local_offer_outlined),
        SizedBox(width: 4),
        Text(listModel?.tag ?? ''),
      ],
    );
  }
}
