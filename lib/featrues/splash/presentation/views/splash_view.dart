import 'package:final_project/featrues/splash/presentation/views/widgets/splash_logo.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonOpacityAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.elasticOut,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );

    _buttonOpacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              0.6,
              1.0,
              curve: Curves.easeInOut,
            ),
          ),
        );

    _buttonSlideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 1.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              0.6,
              1.0,
              curve: Curves.easeOutBack,
            ),
          ),
        );

    _controller.forward();

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  void _navigateToSignIn() {
    _controller.stop();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyBlue,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.navyBlue,
              AppColors.mediumNavy,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        SplashLogo(),
                        const SizedBox(height: 32),
                        const Text(
                          'ShopEasy',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start your shopping journey now',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.white
                                .withValues(alpha: 0.8),
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity:
                          _buttonOpacityAnimation.value,
                      child: Transform.translate(
                        offset:
                            _buttonSlideAnimation.value *
                            50,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.orange,
                              AppColors.lightOrange,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.orange
                                  .withValues(alpha: 0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _navigateToSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.transparent,
                            foregroundColor:
                                AppColors.white,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.w700,
                                  color: AppColors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 20,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _navigateToSignIn,
                        child: Text(
                          'Skip for now',
                          style: TextStyle(
                            color: AppColors.white
                                .withValues(alpha: 0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration:
                                TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Auto redirect in 8 seconds',
                        style: TextStyle(
                          color: AppColors.white
                              .withValues(alpha: 0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
