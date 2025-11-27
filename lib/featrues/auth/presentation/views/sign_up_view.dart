import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_validation.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
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
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Back Button
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.navyBlue,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mediumNavy,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Join us and start shopping',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 40),

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
                const SizedBox(height: 20),

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
                const SizedBox(height: 20),

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
                const SizedBox(height: 20),

                // Confirm Password
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  preFixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.mediumNavy,
                  ),
                  isPassword: true,
                  validator: (value) =>
                      AppValidation.validateConfirmPassword(
                        value,
                        passwordController.text,
                      ),
                ),

                const SizedBox(height: 30),

                // Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
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
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: AppColors.grey),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(
                            context,
                            '/',
                          ),
                      child: Text(
                        'Sign In',
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
