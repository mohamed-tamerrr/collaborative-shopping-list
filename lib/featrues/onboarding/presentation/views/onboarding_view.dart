import 'package:final_project/core/services/local_storage_service.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/featrues/onboarding/data/models/onboarding_page_data.dart';
import 'package:final_project/featrues/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:flutter/material.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = [
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

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
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
    // final isVerySmallScreen = screenHeight < 600;

    return Scaffold(
      backgroundColor: AppColors.navyBlue,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.navyBlue, AppColors.mediumNavy],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  // Skip button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: isSmallScreen ? 12.0 : 24.0,
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: _skipOnboarding,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // PageView
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return OnboardingPage(
                          data: _pages[index],
                          pageIndex: index,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (index) =>
                                _buildPageIndicator(index == _currentPage),
                          ),
                        ),

                        SizedBox(height: isSmallScreen ? 16.0 : 24.0),

                        // Get Started button with gradient (matching splash)
                        _buildGradientButton(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.orange
            : AppColors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildGradientButton() {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.orange, AppColors.lightOrange],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
