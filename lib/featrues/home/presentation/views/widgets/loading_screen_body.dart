import 'package:final_project/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingScreenBody extends StatelessWidget {
  const LoadingScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppColors.navyBlue)),
    );
  }
}
