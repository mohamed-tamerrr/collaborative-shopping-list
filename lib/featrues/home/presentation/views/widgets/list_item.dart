import 'package:final_project/core/utils/app_images.dart';
import 'package:final_project/featrues/home/data/models/list_model.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/items_view.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_icon.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/group_avatar.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/list_item_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.listModel,
    required this.listId,
  });

  final ListModel listModel;
  final String listId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ListCubit>().currentListId = listId;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ItemsView(
              listModel: listModel,
              listId: listId,
              tagName: listModel.tag,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xffEAECF0),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 24,
            right: 10,
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    listModel.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  const Align(
                    alignment: Alignment.topRight,
                    child: CustomIcon(icon: Icons.favorite),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const GroupAvatars(
                imageUrls: [
                  AppImages.avatar,
                  AppImages.avatar,
                  AppImages.avatar,
                  AppImages.avatar,
                ],
              ),

              const SizedBox(height: 8),

              StreamBuilder(
                stream: context
                    .read<ListCubit>()
                    .itemsCountStream(listId),
                builder: (context, snapshot) {
                  int completed = 0;
                  int total = 0;

                  if (snapshot.hasData) {
                    completed = snapshot.data!['completed']!;
                    total = snapshot.data!['total']!;
                  }

                  return ListItemInfo(
                    itemslength: total,
                    doneItemslength: completed,
                    tagName: listModel.tag,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
