import 'package:final_project/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AddPeopleContainer extends StatelessWidget {
  const AddPeopleContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: BoxBorder.all(color: AppColors.grey),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,

              // to see how it is gonna be with alot of rows
              children: const [
                AddedPersonRow(
                  email: 'nourmowafey82@gmail.commmmmmmmmmmmmmmmmmmmm',
                ),
                AddedPersonRow(
                  email: 'nourmowafey82@gmail.commmmmmmmmmmmmmmmmmmmm',
                ),
                AddedPersonRow(
                  email: 'nourmowafey82@gmail.commmmmmmmmmmmmmmmmmmmm',
                ),
                AddedPersonRow(
                  email: 'nourmowafey82@gmail.commmmmmmmmmmmmmmmmmmmm',
                ),
                AddedPersonRow(
                  email: 'nourmowafey82@gmail.commmmmmmmmmmmmmmmmmmmm',
                ),
                AddedPersonRow(
                  email: 'nourmowafey82@gmail.commmmmmmmmmmmmmmmmmmmm',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  padding: EdgeInsets.only(right: 4),
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddedPersonRow extends StatelessWidget {
  const AddedPersonRow({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 12, right: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            // to make max length for email is 26 letter
            email.length > 26 ? email.substring(0, 26) : email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.navyBlue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(Icons.remove),
        ],
      ),
    );
  }
}
