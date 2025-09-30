import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_images.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  // ! Colors must be changed
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.lightGrey,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: AppColors.mediumNavy),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomAppBar(),
            Spacer(flex: 2),
            // this stack to make arrow under the the image
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 90,
                  top: 270,
                  // to rotate the image beacuse it is rotated in the design
                  child: Transform.rotate(
                    angle: -0.07,
                    child: SvgPicture.asset(AppImages.handDrawnArrow),
                  ),
                ),
                Positioned(child: SvgPicture.asset(AppImages.emptySreen)),
              ],
            ),

            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
