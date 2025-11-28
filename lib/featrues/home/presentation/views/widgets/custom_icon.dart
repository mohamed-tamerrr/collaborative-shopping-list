import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({super.key, this.icon, this.onPressed});
  final IconData? icon;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: const Color(0xffB692F6).withValues(alpha: 0.1),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Color(0xffB692F6)),
      ),
    );
  }
}
