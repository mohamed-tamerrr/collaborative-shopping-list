import 'package:flutter/material.dart';

class ListItemInfo extends StatelessWidget {
  const ListItemInfo({
    super.key,
    this.itemslength,
    this.tagName,
    this.doneItemslength,
  });

  final int? itemslength;
  final int? doneItemslength;
  final String? tagName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.list),
        const SizedBox(width: 4),
        Text(
          'List ${doneItemslength ?? 0}/${itemslength ?? 0} Completed',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 56),
        const Icon(Icons.local_offer_outlined),
        const SizedBox(width: 4),
        Text(
          tagName!.length >= 12
              ? tagName?.substring(0, 12) ?? ''
              : tagName ?? '',
        ),
      ],
    );
  }
}
