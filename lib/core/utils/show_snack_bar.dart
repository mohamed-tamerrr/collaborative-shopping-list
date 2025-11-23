import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  Color? color,
  String? content,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(content ?? 'something went wrong'),
    ),
  );
}
