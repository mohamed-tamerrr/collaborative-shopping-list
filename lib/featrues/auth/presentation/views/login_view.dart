import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_validation.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:final_project/featrues/auth/presentation/views/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  final FirebaseServices _firebaseServices = FirebaseServices();

  late AnimationController _textController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, -0.5),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _textController,
            curve: Curves.easeOut,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );

    _textController.forward();
  }

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _firebaseServices.signIn(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        if (!mounted) return;
        ShowSnackBar.successSnackBar(
          context: context,
          content: 'Sign in successful!',
        );
        Navigator.of(context).pushReplacementNamed('/home');
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        ShowSnackBar.failureSnackBar(
          context: context,
          content: e.message ?? 'Sign in failed',
        );
      } catch (_) {
        if (!mounted) return;
        ShowSnackBar.failureSnackBar(
          context: context,
          content: 'Sign in failed',
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mediumNavy,
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                Text(
                  'Sign in to continue shopping',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                  ),
                ),

                const SizedBox(height: 40),

                CustomTextField(
                  preFixIcon: const Icon(
                    Icons.email,
                    color: AppColors.mediumNavy,
                  ),
                  labelText: 'Email',
                  controller: emailController,
                  validator: AppValidation.validateEmail,
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: passwordController,
                  labelText: 'Password',
                  preFixIcon: const Icon(
                    Icons.lock,
                    color: AppColors.mediumNavy,
                  ),
                  isPassword: true,
                  validator: AppValidation.validatePassword,
                ),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/forgot-password',
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                    AppColors.white,
                                  ),
                            ),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: AppColors.grey),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/signup',
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
