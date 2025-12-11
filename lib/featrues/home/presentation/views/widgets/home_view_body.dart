import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_styles.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/add_list_view.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_app_bar.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/list_item.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/loading_screen_body.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/no_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  @override
  void initState() {
    super.initState();
    context.read<ListCubit>().listenToLists();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListCubit, ListState>(
      builder: (context, state) {
        if (state is ListLoading) {
          return LoadingScreenBody();
        } else if (state is ListFailure) {
          return Center(child: Text('Failure')); //! : bad practice !!
        } else if (state is ListSuccess) {
          if (state.lists.isEmpty) {
            return const NoListPage();
          }
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => AddListView()));
              },
              backgroundColor: AppColors.mediumNavy,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: AppColors.white),
            ),
            body: Padding(
              padding: AppStyles.screenPaddingHorizontal,
              child: SafeArea(
                child: Column(
                  children: [
                    CustomAppBar(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.listsLength,
                        itemBuilder: (context, index) {
                          final String listId = state.lists[index].id;
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
