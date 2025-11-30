import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_images.dart';
import 'package:final_project/featrues/home/presentation/views/add_list_view.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoListPage extends StatelessWidget {
  const NoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddListView()));
        },
        backgroundColor: AppColors.orange,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              CustomAppBar(),
              const Spacer(flex: 2),
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
                  SvgPicture.asset(AppImages.emptySreen),
                ],
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
