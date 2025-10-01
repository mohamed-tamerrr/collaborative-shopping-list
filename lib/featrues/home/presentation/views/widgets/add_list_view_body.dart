import 'package:flutter/material.dart';

class AddListViewBody extends StatefulWidget {
  const AddListViewBody({super.key});

  @override
  State<AddListViewBody> createState() =>
      _AddListViewBodyState();
}

// todo : Refactor + decide how the ui will be
class _AddListViewBodyState extends State<AddListViewBody> {
  bool isSharedList = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'New List',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            "List Name:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          // ListName TextField
          TextFormField(
            decoration: InputDecoration(
              hintText: "Enter List Name",
              border: borderStyle(),
              enabledBorder: borderStyle(),
              focusedBorder: borderStyle(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Notes:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          // Notes TextField
          TextFormField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText:
                  "Add any additional information or reminders for your list here.",
              border: borderStyle(),
              enabledBorder: borderStyle(),
              focusedBorder: borderStyle(),
            ),
          ),

          const SizedBox(height: 20),

          // List Type row
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "List Type",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  const Text("Shared List"),
                  Switch(
                    value: isSharedList,
                    onChanged: (value) {
                      setState(() {
                        isSharedList = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Add items button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Add Items",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder borderStyle() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff8A888D)),
      borderRadius: BorderRadius.circular(8),
    );
  }
}
