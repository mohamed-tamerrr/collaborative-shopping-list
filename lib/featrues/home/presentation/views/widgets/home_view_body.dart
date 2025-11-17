import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_images.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/add_list_view.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_app_bar.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/list_item.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/loading_screen_body.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/no_list_page.dart';
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
          return LoadingScreenBody();
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.listsLength,
                        itemBuilder: (context, index) {
                          final String listId =
                              state.lists[index].id;
                          return ListItem(
                            listModel: state.lists[index],
                            listId: listId,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return NoListPage();
        }
      },
    );
  }
}
