import 'package:flutter/material.dart';

class ListItemInfo extends StatelessWidget {
  const ListItemInfo({super.key, this.itemslength,  this.tagName});
  final int? itemslength;
  final String? tagName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.list),
        SizedBox(width: 4),
        Text('List 0/${itemslength ?? 0} Completed'),
        SizedBox(width: 56),
        Icon(Icons.local_offer_outlined),
        SizedBox(width: 4),
        Text(tagName ?? ''),
      ],
    );
  }
}
