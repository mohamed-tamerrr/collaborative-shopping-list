import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/user_avatar.dart';
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
  // Store details of manually added users: {id, email}
  final List<Map<String, String>> _addedUsers = [];

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
            child: _addedUsers.isEmpty
                ? const Center(
                    child: Text(
                      'No users added yet.\nTap "+" to add by email.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _addedUsers.length,
                    itemBuilder: (context, index) {
                      final userMap = _addedUsers[index];
                      final userId = userMap['id']!;
                      final email = userMap['email']!;
                      final name = userMap['name'] ?? 'Unknown';
                      final photoUrl = userMap['photoUrl'];
                      final isSelected = _selectedUserIds.contains(userId);

                      return AddedPersonRow(
                        email: email,
                        name: name,
                        photoUrl: photoUrl,
                        isSelected: isSelected,
                        onTap: () {
                          // Allow toggling selection or removing entirely
                          // For now, let's just toggle selection as per original logic,
                          // but since they manually added them, they probably want them selected.
                          // If we strictly follow "add by email", maybe we should just allow deleting from list?
                          // The original requirement says "add the users i want with email".
                          // So let's keep the selection logic but maybe add a delete button?
                          // The row has a 'check_circle' if selected.

                          setState(() {
                            if (isSelected) {
                              _selectedUserIds.remove(userId);
                            } else {
                              _selectedUserIds.add(userId);
                            }
                          });
                          widget.onSelectionChanged?.call(_selectedUserIds);
                        },
                        onRemove: () {
                          setState(() {
                            _selectedUserIds.remove(userId);
                            _addedUsers.removeAt(index);
                          });
                          widget.onSelectionChanged?.call(_selectedUserIds);
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
                TextButton.icon(
                  onPressed: () {
                    _showAddEmailDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add User"),
                ),
                const SizedBox(width: 8),
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

              // Check if already added
              final alreadyAdded = _addedUsers.any((u) => u['email'] == email);
              if (alreadyAdded) {
                ShowSnackBar.failureSnackBar(
                  context: context,
                  content: 'User already added to the list',
                );
                return;
              }

              final currentUser = _firebaseServices.currentUser;
              if (currentUser != null && currentUser.email == email) {
                ShowSnackBar.failureSnackBar(
                  context: context,
                  content: 'You cannot add yourself',
                );
                return;
              }

              final userDoc = await _firebaseServices.getUserByEmail(email);
              if (userDoc != null && userDoc.exists) {
                final userId = userDoc.id;
                final userData = userDoc.data()!;
                setState(() {
                  _addedUsers.add({
                    'id': userId,
                    'email': email,
                    'name': userData['name'] ?? 'Unknown',
                    'photoUrl': userData['photoUrl'] ?? '',
                  });
                  _selectedUserIds.add(userId);
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
    this.name,
    this.photoUrl,
    this.isSelected = false,
    this.onTap,
    this.onRemove,
  });
  final String email;
  final String? name;
  final String? photoUrl;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 12, right: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            UserAvatar(name: name ?? '', photoUrl: photoUrl, radius: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? 'Unknown',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? AppColors.orange : AppColors.navyBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    email.length > 26 ? email.substring(0, 26) : email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.orange,
                  size: 20,
                ),
              ),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              color: AppColors.grey,
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
