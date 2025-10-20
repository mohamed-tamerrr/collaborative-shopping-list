import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_images.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/add_list_view.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_app_bar.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ListCubit>().listenToLists();
    return BlocBuilder<ListCubit, ListState>(
      builder: (context, state) {
        if (state is ListLoading) {
          return CircularProgressIndicator();
        } else if (state is ListFailure) {
          return Center(child: Text('Failure'));
        } else if (state is ListSuccess) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddListView(),
                  ),
                );
              },
              backgroundColor: AppColors.lightGrey,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                color: AppColors.mediumNavy,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    const CustomAppBar(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: ListItem(),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddListView(),
                  ),
                );
              },
              backgroundColor: AppColors.lightGrey,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                color: AppColors.mediumNavy,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  const CustomAppBar(),
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
                          child: SvgPicture.asset(
                            AppImages.handDrawnArrow,
                          ),
                        ),
                      ),
                      SvgPicture.asset(AppImages.emptySreen),
                    ],
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
