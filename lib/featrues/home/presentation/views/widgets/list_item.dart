import 'package:final_project/core/utils/app_images.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/group_avatar.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffEAECF0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          top: 16,
          right: 16,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                backgroundColor: const Color(
                  0xffB692F6,
                ).withOpacity(.1),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite,
                    color: Color(0xffB692F6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Grocery Shopping List',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
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
          ],
        ),
      ),
    );
  }
}
