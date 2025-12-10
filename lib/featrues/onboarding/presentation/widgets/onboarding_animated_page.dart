import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/featrues/onboarding/data/models/onboarding_page_data.dart';
import 'package:flutter/material.dart';

class OnboardingAnimatedPage extends StatefulWidget {
  const OnboardingAnimatedPage({super.key, required this.data});

  final OnboardingPageData data;

  @override
  State<OnboardingAnimatedPage> createState() =>
      _OnboardingAnimatedPageState();
}

class _OnboardingAnimatedPageState
    extends State<OnboardingAnimatedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconScale;
  late Animation<double> _iconFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _iconScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _iconFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    _textSlide =
        Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(
              0.4,
              1.0,
              curve: Curves.easeOut,
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    final isVerySmallScreen = screenHeight < 600;

    // Calculate responsive sizes
    final iconSize = isVerySmallScreen
        ? screenWidth * 0.35
        : isSmallScreen
        ? screenWidth * 0.4
        : screenWidth * 0.5;
    final iconInnerSize = iconSize * 0.5;
    final titleFontSizeRaw = isVerySmallScreen
        ? screenWidth * 0.08
        : isSmallScreen
        ? screenWidth * 0.09
        : screenWidth * 0.11;
    final titleFontSize = titleFontSizeRaw < 28.0
        ? 28.0
        : titleFontSizeRaw > 42.0
        ? 42.0
        : titleFontSizeRaw;
    final descriptionFontSize = isVerySmallScreen
        ? 14.0
        : isSmallScreen
        ? 15.0
        : 16.0;
    final horizontalPadding = screenWidth * 0.06;
    final spacingBetweenIconAndTitle = isVerySmallScreen
        ? 24.0
        : isSmallScreen
        ? 32.0
        : 48.0;
    final spacingBetweenTitleAndDescription = isVerySmallScreen
        ? 12.0
        : 16.0;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              screenHeight -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom -
              200,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: isVerySmallScreen ? 20.0 : 40.0),

              // Animated Icon/Illustration
              _buildAnimatedIcon(iconSize, iconInnerSize),

              SizedBox(height: spacingBetweenIconAndTitle),

              // Animated Title
              _buildAnimatedTitle(titleFontSize),

              SizedBox(
                height: spacingBetweenTitleAndDescription,
              ),

              // Animated Description
              _buildAnimatedDescription(
                descriptionFontSize,
                screenWidth,
              ),

              SizedBox(height: isVerySmallScreen ? 20.0 : 40.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(
    double iconSize,
    double iconInnerSize,
  ) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _iconFade.value,
          child: Transform.scale(
            scale: _iconScale.value,
            child: child,
          ),
        );
      },
      child: Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          widget.data.icon,
          size: iconInnerSize,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildAnimatedTitle(double titleFontSize) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _textFade.value,
          child: SlideTransition(
            position: _textSlide,
            child: child,
          ),
        );
      },
      child: Text(
        widget.data.title,
        style: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.w800,
          color: AppColors.white,
          letterSpacing: 1.2,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildAnimatedDescription(
    double descriptionFontSize,
    double screenWidth,
  ) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _textFade.value,
          child: SlideTransition(
            position: _textSlide,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
        ),
        child: Text(
          widget.data.description,
          style: TextStyle(
            fontSize: descriptionFontSize,
            color: AppColors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
