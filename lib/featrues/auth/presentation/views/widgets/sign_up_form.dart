import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_validation.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:final_project/featrues/auth/presentation/views/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'footer_sign_in.dart';
import 'sign_up_button.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  final FirebaseServices firebase = FirebaseServices();

  @override
  void dispose() {
    _nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await firebase.signUp(
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
    } catch (e) {
      if (!mounted) return;

      String errorMessage = e.toString();
      if (e is FirebaseAuthException) {
        errorMessage = FirebaseServices.getAuthErrorMessage(e.code);
      }

      ShowSnackBar.failureSnackBar(context: context, content: errorMessage);
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _nameController,
            labelText: 'Full Name',
            validator: AppValidation.validateName,
            preFixIcon: const Icon(Icons.person, color: AppColors.mediumNavy),
          ),
          const SizedBox(height: 20),

          CustomTextField(
            controller: emailController,
            labelText: 'Email',
            validator: AppValidation.validateEmail,
            preFixIcon: const Icon(Icons.email, color: AppColors.mediumNavy),
          ),
          const SizedBox(height: 20),

          CustomTextField(
            controller: passwordController,
            labelText: 'Password',
            isPassword: true,
            validator: AppValidation.validatePassword,
            preFixIcon: const Icon(Icons.lock, color: AppColors.mediumNavy),
          ),
          const SizedBox(height: 20),

          CustomTextField(
            controller: confirmPasswordController,
            labelText: 'Confirm Password',
            isPassword: true,
            validator: (value) => AppValidation.validateConfirmPassword(
              value,
              passwordController.text,
            ),
            preFixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.mediumNavy,
            ),
          ),

          const SizedBox(height: 35),
          SignUpButton(isLoading: isLoading, onPressed: _signUp),

          const SizedBox(height: 25),
          const FooterSignIn(),
        ],
      ),
    );
  }
}
