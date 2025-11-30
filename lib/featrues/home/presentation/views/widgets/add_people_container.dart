import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:flutter/material.dart';

class AddPeopleContainer extends StatefulWidget {
  const AddPeopleContainer({super.key, this.onSelectionChanged});

  final void Function(Set<String> selectedIds)? onSelectionChanged;

  @override
  State<AddPeopleContainer> createState() => _AddPeopleContainerState();
}

class _AddPeopleContainerState extends State<AddPeopleContainer> {
  final FirebaseServices _firebaseServices = FirebaseServices();
  final Set<String> _selectedUserIds = {};
  final Map<String, String> _userEmails = {}; // userId -> email mapping

  @override
  Widget build(BuildContext context) {
    final currentUser = _firebaseServices.currentUser;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey),
      ),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _firebaseServices.getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No users found'));
                }

                final users = snapshot.data!.docs
                    .where((doc) => doc.id != currentUser.uid)
                    .toList();

                if (users.isEmpty) {
                  return const Center(child: Text('No other users available'));
                }

                // Update email mapping
                for (var doc in users) {
                  final data = doc.data();
                  _userEmails[doc.id] = data['email'] ?? '';
                }

                if (users.isEmpty) {
                  return const Center(child: Text('No users to share with'));
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final userDoc = users[index];
                    final userId = userDoc.id;
                    final userData = userDoc.data();
                    final email = userData['email'] ?? '';
                    final isSelected = _selectedUserIds.contains(userId);

                    return AddedPersonRow(
                      email: email,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedUserIds.remove(userId);
                          } else {
                            _selectedUserIds.add(userId);
                          }
                        });
                        widget.onSelectionChanged?.call(_selectedUserIds);
                      },
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  padding: const EdgeInsets.only(right: 4),
                  onPressed: () {
                    _showAddEmailDialog(context);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEmailDialog(BuildContext context) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add User by Email'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Enter user email',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isEmpty) {
                ShowSnackBar.failureSnackBar(
                  context: context,
                  content: 'Please enter an email',
                );
                return;
              }

              final userDoc = await _firebaseServices.getUserByEmail(email);
              if (userDoc != null && userDoc.exists) {
                final userId = userDoc.id;
                setState(() {
                  _selectedUserIds.add(userId);
                  _userEmails[userId] = email;
                });
                widget.onSelectionChanged?.call(_selectedUserIds);
                if (context.mounted) {
                  Navigator.pop(context);
                  ShowSnackBar.successSnackBar(
                    context: context,
                    content: 'User added',
                  );
                }
              } else {
                if (context.mounted) {
                  ShowSnackBar.failureSnackBar(
                    context: context,
                    content: 'User not found',
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class AddedPersonRow extends StatelessWidget {
  const AddedPersonRow({
    super.key,
    required this.email,
    this.isSelected = false,
    this.onTap,
  });
  final String email;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 12, right: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.orange, size: 20)
            else
              const Icon(
                Icons.radio_button_unchecked,
                color: AppColors.grey,
                size: 20,
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                // to make max length for email is 26 letter
                email.length > 26 ? email.substring(0, 26) : email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? AppColors.orange : AppColors.navyBlue,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: AppColors.grey,
                onPressed: onTap,
              ),
          ],
        ),
      ),
    );
  }
}
