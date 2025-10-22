import 'package:final_project/core/utils/app_images.dart';
import 'package:final_project/featrues/home/data/models/list_model.dart';
import 'package:final_project/featrues/home/presentation/views/items_view.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_icon.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/group_avatar.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/list_item_info.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.listModel});
  final ListModel listModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => ItemsView())),
      child: Container(
        margin: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffEAECF0), width: 2),
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
                    style: TextStyle(
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
              GroupAvatars(
                imageUrls: [
                  AppImages.avatar,
                  AppImages.avatar,
                  AppImages.avatar,
                  AppImages.avatar,
                ],
              ),
              SizedBox(height: 8),
              ListItemInfo(listModel: listModel),
            ],
          ),
        ),
      ),
    );
  }
}
