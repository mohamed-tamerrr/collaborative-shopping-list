import 'package:flutter/material.dart';

class CustomTextFormFieldWithTitle extends StatelessWidget {
  const CustomTextFormFieldWithTitle({
    super.key,
    required this.hintText,
    this.maxLines = 1,
    this.title,
    this.controller,
  });
  final String hintText;
  final String? title;
  final int? maxLines;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            border: borderStyle(),
            enabledBorder: borderStyle(),
            focusedBorder: borderStyle(),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder borderStyle() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xff8A888D)),
      borderRadius: BorderRadius.circular(8),
    );
  }
}
