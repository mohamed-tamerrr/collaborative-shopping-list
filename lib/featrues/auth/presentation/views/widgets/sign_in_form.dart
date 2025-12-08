import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_validation.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:final_project/featrues/auth/presentation/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import 'sign_in_button.dart';
import 'forgot_password_button.dart';
import 'footer_sign_up.dart';

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

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      ShowSnackBar.failureSnackBar(
        context: context,
        content: e.toString(),
      );
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: email,
            labelText: 'Email',
            validator: AppValidation.validateEmail,
            preFixIcon: const Icon(
              Icons.email,
              color: AppColors.mediumNavy,
            ),
          ),
          const SizedBox(height: 20),

          CustomTextField(
            controller: password,
            labelText: 'Password',
            validator: AppValidation.validatePassword,
            isPassword: true,
            preFixIcon: const Icon(
              Icons.lock,
              color: AppColors.mediumNavy,
            ),
          ),

          const ForgotPasswordButton(),

          const SizedBox(height: 20),
          SignInButton(isLoading: _loading, onPressed: _signIn),

          const FooterSignUp(),
        ],
      ),
    );
  }
}
