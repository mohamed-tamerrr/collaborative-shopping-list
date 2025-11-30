import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Unified design system for consistent spacing, typography, and styles
class AppStyles {
  // Private constructor to prevent instantiation
  AppStyles._();

  // ========== Spacing ==========
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 20.0;
  static const double spacingXXL = 24.0;
  static const double spacingXXXL = 30.0;
  static const double spacingHuge = 40.0;

  // Standard screen padding
  static const EdgeInsets screenPadding = EdgeInsets.all(24.0);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(
    horizontal: 24.0,
  );
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(
    vertical: 24.0,
  );

  // ========== Typography ==========
  // Headings
  static TextStyle heading1({Color? color}) => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: color ?? AppColors.mediumNavy,
    letterSpacing: -0.5,
  );

  static TextStyle heading2({Color? color}) => TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.mediumNavy,
    letterSpacing: -0.3,
  );

  static TextStyle heading3({Color? color}) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.mediumNavy,
  );

  // Body text
  static TextStyle bodyLarge({Color? color}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: color ?? AppColors.grey,
  );

  static TextStyle bodyMedium({Color? color}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: color ?? AppColors.grey,
  );

  static TextStyle bodySmall({Color? color}) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: color ?? AppColors.grey,
  );

  // Labels
  static TextStyle label({Color? color, FontWeight? fontWeight}) => TextStyle(
    fontSize: 14,
    fontWeight: fontWeight ?? FontWeight.w500,
    color: color ?? AppColors.mediumNavy,
  );

  // Links/Buttons
  static TextStyle link({Color? color}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.orange,
  );

  // ========== Button Styles ==========
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.orange,
    foregroundColor: AppColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 0,
    minimumSize: const Size(double.infinity, 56),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  );

  // Orange gradient button style (for special actions)
  static ButtonStyle orangeGradientButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.white,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0,
    minimumSize: const Size(double.infinity, 60),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  );

  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.mediumNavy,
    foregroundColor: AppColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 0,
    minimumSize: const Size(double.infinity, 56),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  );

  // Outlined button style with navy blue border
  static ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: AppColors.mediumNavy,
    side: const BorderSide(color: AppColors.mediumNavy, width: 1.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    minimumSize: const Size(double.infinity, 56),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  );

  // Text button style with orange color
  static ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: AppColors.orange,
    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  );

  // ========== Input Decoration ==========
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    filled: true,
    fillColor: AppColors.white,
  );

  // ========== Card Styles ==========
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.lightGrey.withValues(alpha: 0.4),
    borderRadius: BorderRadius.circular(12),
  );

  // ========== Back Button Container ==========
  static BoxDecoration backButtonDecoration = BoxDecoration(
    color: AppColors.lightGrey,
    borderRadius: BorderRadius.circular(10),
  );

  // ========== Color Usage Guidelines ==========
  // Primary Actions: Use AppColors.orange
  // Secondary Actions: Use AppColors.lightOrange
  // Headings/Text: Use AppColors.navyBlue, AppColors.mediumNavy, or AppColors.lightNavy
  // Backgrounds: Use AppColors.white or AppColors.lightGrey
  // Accents: Use AppColors.orange for highlights and CTAs

  // ========== Loading Indicator ==========
  static Widget loadingIndicator({Color? color, double? size}) => SizedBox(
    width: size ?? 20,
    height: size ?? 20,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.white),
    ),
  );
}
