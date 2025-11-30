import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/app_validation.dart';
import '../../../../core/widgets/unified_back_button.dart';
import '../../../../featrues/auth/presentation/views/widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String?;

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
                Text('Reset Password', style: AppStyles.heading1()),
                const SizedBox(height: AppStyles.spacingS),
                Text('Create your new password', style: AppStyles.bodyLarge()),
                if (email != null) ...[
                  const SizedBox(height: AppStyles.spacingS),
                  Text(
                    'for $email',
                    style: AppStyles.bodyMedium(
                      color: AppColors.mediumNavy,
                    ).copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
                const SizedBox(height: AppStyles.spacingHuge),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'New Password',
                  preFixIcon: const Icon(
                    Icons.lock,
                    color: AppColors.mediumNavy,
                  ),
                  isPassword: true,
                  validator: AppValidation.validatePassword,
                ),
                const SizedBox(height: AppStyles.spacingXL),
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm New Password',
                  preFixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.mediumNavy,
                  ),
                  isPassword: true,
                  validator: (value) => AppValidation.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                ),
                const SizedBox(height: AppStyles.spacingXXXL),
                ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  style: AppStyles.primaryButtonStyle,
                  child: _isLoading
                      ? AppStyles.loadingIndicator()
                      : const Text(
                          'Reset Password',
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
