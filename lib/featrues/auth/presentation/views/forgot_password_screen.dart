import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/app_validation.dart';
import '../../../../core/widgets/unified_back_button.dart';
import '../../../../featrues/auth/presentation/views/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  void _sendResetLink() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Navigate to reset password screen
      Navigator.pushNamed(
        context,
        '/reset-password',
        arguments: _emailController.text,
      );
    }
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
                const UnifiedBackButton(),
                const SizedBox(height: AppStyles.spacingXXXL),
                Text('Forgot Password', style: AppStyles.heading1()),
                const SizedBox(height: AppStyles.spacingS),
                Text(
                  "Enter your email and we'll send you a reset link",
                  style: AppStyles.bodyLarge(),
                ),
                const SizedBox(height: AppStyles.spacingHuge),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  preFixIcon: const Icon(
                    Icons.email,
                    color: AppColors.mediumNavy,
                  ),
                  validator: AppValidation.validateEmail,
                ),
                const SizedBox(height: AppStyles.spacingXXXL),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendResetLink,
                  style: AppStyles.primaryButtonStyle,
                  child: _isLoading
                      ? AppStyles.loadingIndicator()
                      : const Text(
                          'Send Reset Link',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
