import 'package:final_project/core/services/local_storage_service.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/onboarding_constants.dart';
import 'package:final_project/featrues/onboarding/presentation/widgets/gradient_button.dart';
import 'package:final_project/featrues/onboarding/presentation/widgets/onboarding_animated_page.dart';
import 'package:final_project/featrues/onboarding/presentation/widgets/page_indicator.dart';
import 'package:final_project/featrues/onboarding/presentation/widgets/skip_button.dart';

import 'package:flutter/material.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < OnboardingConstants.pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(
          milliseconds:
              OnboardingConstants.pageTransitionDuration,
        ),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await LocalStorageService.setOnboardingCompleted(true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: AppColors.navyBlue,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              OnboardingConstants.backgroundColorStart,
              OnboardingConstants.backgroundColorEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: isSmallScreen ? 12.0 : 24.0,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: SkipButton(onPressed: _skipOnboarding),
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: OnboardingConstants.pages.length,
                  itemBuilder: (context, index) {
                    return OnboardingAnimatedPage(
                      data: OnboardingConstants.pages[index],
                    );
                  },
                ),
              ),

              // Page indicator and navigation
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: isSmallScreen ? 16.0 : 32.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: List.generate(
                        OnboardingConstants.pages.length,
                        (index) => PageIndicator(
                          isActive: index == _currentPage,
                          duration: const Duration(
                            milliseconds: OnboardingConstants
                                .indicatorAnimationDuration,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: isSmallScreen ? 16.0 : 24.0,
                    ),

                    // Get Started button
                    GradientButton(
                      text:
                          _currentPage ==
                              OnboardingConstants.pages.length -
                                  1
                          ? 'Get Started'
                          : 'Next',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: _nextPage,
                      height: OnboardingConstants.buttonHeight,
                      borderRadius:
                          OnboardingConstants.buttonBorderRadius,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
