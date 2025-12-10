import 'package:final_project/featrues/onboarding/data/models/onboarding_page_data.dart';
import 'package:final_project/featrues/onboarding/presentation/views/onboarding_view.dart'
    hide OnboardingPageData;

import 'package:flutter/material.dart';

class OnboardingConstants {
  static const backgroundColorStart = Color(0xFF1A237E);
  static const backgroundColorEnd = Color(0xFF283593);
  static const buttonHeight = 60.0;
  static const buttonBorderRadius = 16.0;
  static const buttonFontSize = 18.0;
  static const pageTransitionDuration = 300;
  static const indicatorAnimationDuration = 300;

  static List<OnboardingPageData> get pages => [
    OnboardingPageData(
      title: 'Welcome to ShopEasy',
      description:
          'Your smart shopping companion that helps you organize, share, and never forget what you need.',
      icon: Icons.shopping_cart_rounded,
    ),
    OnboardingPageData(
      title: 'Create & Organize',
      description:
          'Easily create shopping lists with tags and notes. Keep everything organized and accessible.',
      icon: Icons.checklist_rounded,
    ),
    OnboardingPageData(
      title: 'Share & Collaborate',
      description:
          'Share your lists with family and friends. Shop together and stay in sync in real-time.',
      icon: Icons.people_rounded,
    ),
  ];
}
