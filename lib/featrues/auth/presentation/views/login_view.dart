import 'package:flutter/material.dart';
import 'widgets/sign_in_header.dart';
import 'widgets/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SignInHeader(),
                SizedBox(height: 40),
                SignInForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
