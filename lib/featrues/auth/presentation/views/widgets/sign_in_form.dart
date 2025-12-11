import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_validation.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:final_project/featrues/auth/presentation/views/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'footer_sign_up.dart';
import 'forgot_password_button.dart';
import 'sign_in_button.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  bool _loading = false;
  final FirebaseServices _firebase = FirebaseServices();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await _firebase.signIn(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      if (!mounted) return;

      ShowSnackBar.successSnackBar(
        context: context,
        content: 'Sign in successful!',
      );

      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } catch (e) {
      if (!mounted) return;
      String errorMessage = e.toString();
      if (e is FirebaseAuthException) {
        errorMessage = FirebaseServices.getAuthErrorMessage(e.code);
      }
      ShowSnackBar.failureSnackBar(context: context, content: errorMessage);
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: email,
            labelText: 'Email',
            validator: AppValidation.validateEmail,
            preFixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.mediumNavy,
            ),
          ),
          const SizedBox(height: 24),

          CustomTextField(
            controller: password,
            labelText: 'Password',
            validator: AppValidation.validatePassword,
            isPassword: true,
            preFixIcon: const Icon(
              Icons.lock_outlined,
              color: AppColors.mediumNavy,
            ),
          ),

          const SizedBox(height: 12),
          const ForgotPasswordButton(),

          const SizedBox(height: 32),
          SignInButton(isLoading: _loading, onPressed: _signIn),

          const SizedBox(height: 8),
          const FooterSignUp(),
        ],
      ),
    );
  }
}
