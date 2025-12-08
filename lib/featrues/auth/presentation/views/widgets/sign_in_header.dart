import 'package:final_project/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SignInHeader extends StatefulWidget {
  const SignInHeader({super.key});

  @override
  State<SignInHeader> createState() => _SignInHeaderState();
}

class _SignInHeaderState extends State<SignInHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slide =
        Tween<Offset>(
          begin: const Offset(0, -0.5),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
          ),
        );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Opacity(
          opacity: _fade.value,
          child: SlideTransition(position: _slide, child: child),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome Back!', style: AppStyles.heading1()),
          const SizedBox(height: 5),
          Text(
            'Sign in to continue shopping',
            style: AppStyles.bodyLarge(),
          ),
        ],
      ),
    );
  }
}
