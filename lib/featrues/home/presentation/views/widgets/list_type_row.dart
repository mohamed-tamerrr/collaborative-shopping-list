import 'package:flutter/material.dart';

class ListTypeRow extends StatelessWidget {
  const ListTypeRow({super.key, required this.value, this.onChange});
  final bool value;
  final void Function(bool)? onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "List Type",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            const Text("Shared List"),
            const SizedBox(width: 6),
            Switch(value: value, onChanged: onChange),
          ],
        ),
      ],
    );
  }
}
