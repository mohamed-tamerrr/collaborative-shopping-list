import 'package:final_project/core/utils/app_images.dart';
import 'package:final_project/featrues/home/presentation/views/items_view.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/custom_icon.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/group_avatar.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/list_item_info.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ItemsView()),
      ),
      child: Container(
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
            left: 24,
            top: 24,
            right: 24,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Grocery Shopping List',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  Align(
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
              ListItemInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
