import 'package:flutter/material.dart';

class ShowSnackBar {
  static void failureSnackBar({
    required BuildContext context,
    Color? color,
    String? content,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color ?? Colors.red,
        content: Text(content ?? 'something went wrong'),
      ),
    );
  }

  static void successSnackBar({
    required BuildContext context,
    Color? color,
    required String content,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: color ?? Colors.green, content: Text(content)),
    );
  }
}
