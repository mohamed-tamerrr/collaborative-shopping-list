import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_styles.dart';
import 'package:final_project/core/utils/app_validation.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:final_project/core/widgets/unified_back_button.dart';
import 'package:final_project/featrues/auth/presentation/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  final FirebaseServices _firebaseServices = FirebaseServices();

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await _firebaseServices.signUp(
          name: _nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        if (!mounted) return;
        ShowSnackBar.successSnackBar(
          context: context,
          content: 'Account created successfully!',
        );
        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        ShowSnackBar.failureSnackBar(
          context: context,
          content: e.message ?? 'Unable to create account',
        );
      } catch (_) {
        if (!mounted) return;
        ShowSnackBar.failureSnackBar(
          context: context,
          content: 'Unable to create account',
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
    _nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _confirmPasswordController.dispose();
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
                const SizedBox(height: AppStyles.spacingHuge),

                // Back Button
                const UnifiedBackButton(),

                const SizedBox(height: AppStyles.spacingXXXL),
                Text('Create Account', style: AppStyles.heading1()),
                const SizedBox(height: AppStyles.spacingS),
                Text(
                  'Join us and start shopping',
                  style: AppStyles.bodyLarge(),
                ),
                const SizedBox(height: AppStyles.spacingHuge),

                // Name
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  preFixIcon: const Icon(
                    Icons.person,
                    color: AppColors.mediumNavy,
                  ),
                  validator: AppValidation.validateName,
                ),
                const SizedBox(height: AppStyles.spacingXL),

                // Email
                CustomTextField(
                  controller: emailController,
                  labelText: 'Email',
                  preFixIcon: const Icon(
                    Icons.email,
                    color: AppColors.mediumNavy,
                  ),
                  validator: AppValidation.validateEmail,
                ),
                const SizedBox(height: AppStyles.spacingXL),

                // Password
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
                const SizedBox(height: AppStyles.spacingXL),

                // Confirm Password
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  preFixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.mediumNavy,
                  ),
                  isPassword: true,
                  validator: (value) => AppValidation.validateConfirmPassword(
                    value,
                    passwordController.text,
                  ),
                ),

                const SizedBox(height: AppStyles.spacingXXXL),

                // Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: AppStyles.primaryButtonStyle,
                  child: _isLoading
                      ? AppStyles.loadingIndicator()
                      : const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                const SizedBox(height: AppStyles.spacingXL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: AppStyles.bodyLarge(),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/'),
                      child: Text('Sign In', style: AppStyles.link()),
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
