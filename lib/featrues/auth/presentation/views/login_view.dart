import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_styles.dart';
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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

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
          padding: AppStyles.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppStyles.spacingXL),

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
                  child: Text('Welcome Back!', style: AppStyles.heading1()),
                ),

                const SizedBox(height: AppStyles.spacingS),
                Text(
                  'Sign in to continue shopping',
                  style: AppStyles.bodyLarge(),
                ),

                const SizedBox(height: AppStyles.spacingHuge),

                CustomTextField(
                  preFixIcon: const Icon(
                    Icons.email,
                    color: AppColors.mediumNavy,
                  ),
                  labelText: 'Email',
                  controller: emailController,
                  validator: AppValidation.validateEmail,
                ),

                const SizedBox(height: AppStyles.spacingXL),

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
                const SizedBox(height: AppStyles.spacingS),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/forgot-password'),
                    child: Text('Forgot Password?', style: AppStyles.link()),
                  ),
                ),

                const SizedBox(height: AppStyles.spacingM),

                ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  style: AppStyles.primaryButtonStyle,
                  child: _isLoading
                      ? AppStyles.loadingIndicator()
                      : const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                const SizedBox(height: AppStyles.spacingS),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: AppStyles.bodyLarge(),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: Text('Sign Up', style: AppStyles.link()),
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
