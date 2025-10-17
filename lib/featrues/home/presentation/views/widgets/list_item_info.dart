import 'package:flutter/material.dart';

class ListItemInfo extends StatelessWidget {
  const ListItemInfo({super.key});

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
        Text('Kitchen items'),
      ],
    );
  }
}
