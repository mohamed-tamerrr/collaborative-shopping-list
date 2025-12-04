import 'package:final_project/featrues/splash/presentation/views/widgets/splash_button_section.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'splash_logo_section.dart';

class SplashAnimatedContent extends StatefulWidget {
  final VoidCallback onGetStarted;

  const SplashAnimatedContent({
    super.key,
    required this.onGetStarted,
  });

  @override
  State<SplashAnimatedContent> createState() =>
      _SplashAnimatedContentState();
}

class _SplashAnimatedContentState
    extends State<SplashAnimatedContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1, curve: Curves.easeInOut),
      ),
    );

    _buttonSlide =
        Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(
              0.6,
              1,
              curve: Curves.easeOutBack,
            ),
          ),
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
    return Column(
      children: [
        Expanded(
          child: SplashLogoSection(
            fadeAnimation: _logoFade,
            scaleAnimation: _logoScale,
          ),
        ),
        SplashButtonSection(
          fadeAnimation: _buttonFade,
          slideAnimation: _buttonSlide,
          onPressed: widget.onGetStarted,
        ),
      ],
    );
  }
}
