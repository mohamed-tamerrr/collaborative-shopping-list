import 'package:flutter/material.dart';

class ScreenUtils {
  static bool isVerySmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.height < 600;
  }

  static bool isSmallScreen(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return height >= 600 && height < 700;
  }

  static bool isMediumScreen(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return height >= 700 && height < 850;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.height >= 850;
  }

  static double getResponsiveValue({
    required BuildContext context,
    required double verySmall,
    required double small,
    required double medium,
    required double large,
  }) {
    if (isVerySmallScreen(context)) return verySmall;
    if (isSmallScreen(context)) return small;
    if (isMediumScreen(context)) return medium;
    return large;
  }
}
