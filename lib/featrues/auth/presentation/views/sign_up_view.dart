import 'package:flutter/material.dart';
import 'widgets/sign_up_header.dart';
import 'widgets/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              SignUpHeader(),
              SizedBox(height: 40),
              SignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}
