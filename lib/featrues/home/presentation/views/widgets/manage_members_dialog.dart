import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageMembersDialog extends StatefulWidget {
  final String listId;
  final String listName;
  final List<String> currentMembers;
  final String ownerId;

  const ManageMembersDialog({
    super.key,
    required this.listId,
    required this.listName,
    required this.currentMembers,
    required this.ownerId,
  });

  @override
  State<ManageMembersDialog> createState() => _ManageMembersDialogState();
}

class _ManageMembersDialogState extends State<ManageMembersDialog> {
  final FirebaseServices _firebaseServices = FirebaseServices();
  Set<String> _selectedUserIds = {};
  List<String> _lastMembers = [];
  bool _initialized = false;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = _firebaseServices.currentUser;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Manage Members',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: screenWidth * 0.9 > 500 ? 500 : screenWidth * 0.9,
        constraints: BoxConstraints(maxHeight: screenHeight * 0.55),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('lists')
              .doc(widget.listId)
              .snapshots(),
          builder: (context, listSnapshot) {
            if (listSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!listSnapshot.hasData || !listSnapshot.data!.exists) {
              return const Center(child: Text('List not found'));
            }

            final members =
                List<String>.from(listSnapshot.data!.data()?['members'] ?? []);
            _syncSelectionWithMembers(members, currentUser?.uid);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'Add user by email',
                        onPressed: _showAddEmailDialog,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: currentUser == null
                      ? const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Center(child: Text('Please sign in to manage members')),
                        )
                      : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: _firebaseServices.getAllUsers(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text('Error: ${snapshot.error}'),
                                ),
                              );
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Center(child: Text('No users found'));
                            }

                            final users = snapshot.data!.docs
                                .where((doc) => doc.id != widget.ownerId)
                                .toList();

                            if (users.isEmpty) {
                              return const Center(
                                child: Text('No other users available'),
                              );
                            }

                            return ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final userDoc = users[index];
                                final userId = userDoc.id;
                                final data = userDoc.data();
                                final email = data['email'] ?? '';
                                final isCurrentMember = members.contains(userId);
                                final isSelected = _selectedUserIds.contains(userId);

                                return ListTile(
                                  title: Text(email),
                                  subtitle: isCurrentMember
                                      ? const Text(
                                          'Current member',
                                          style: TextStyle(
                                            color: AppColors.orange,
                                            fontSize: 12,
                                          ),
                                        )
                                      : null,
                                  trailing: Checkbox(
                                    value: isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          _selectedUserIds.add(userId);
                                        } else {
                                          _selectedUserIds.remove(userId);
                                        }
                                      });
                                    },
                                  ),
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        _selectedUserIds.remove(userId);
                                      } else {
                                        _selectedUserIds.add(userId);
                                      }
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
      actionsPadding: const EdgeInsets.all(16),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _handleSave,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  void _syncSelectionWithMembers(List<String> members, String? currentUserId) {
    final currentSet = Set<String>.from(members);
    final lastSet = Set<String>.from(_lastMembers);
    final changed =
        currentSet.length != lastSet.length || currentSet.difference(lastSet).isNotEmpty;

    if (!_initialized || changed) {
      _lastMembers = members;
      _selectedUserIds = members
          .where((id) => id != widget.ownerId && id != currentUserId)
          .toSet();
      _initialized = true;
    }
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    try {
      final listCubit = context.read<ListCubit>();

      // Fetch latest members to avoid races
      final listDoc = await FirebaseFirestore.instance
          .collection('lists')
          .doc(widget.listId)
          .get();
      final members = List<String>.from(listDoc.data()?['members'] ?? []);

      final toAdd =
          _selectedUserIds.where((id) => !members.contains(id)).toList();
      final toRemove = members
          .where((id) =>
              id != widget.ownerId && !_selectedUserIds.contains(id))
          .toList();

      for (final userId in toAdd) {
        await listCubit.inviteUser(
          listId: widget.listId,
          userId: userId,
          context: context,
        );
      }

      for (final userId in toRemove) {
        await listCubit.removeUser(
          listId: widget.listId,
          userId: userId,
          context: context,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Members updated successfully'),
            backgroundColor: AppColors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating members: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showAddEmailDialog() {
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
                final currentUser = _firebaseServices.currentUser;

                if (userId == currentUser?.uid) {
                  ShowSnackBar.failureSnackBar(
                    context: context,
                    content: 'Cannot add yourself',
                  );
                  return;
                }
                if (userId == widget.ownerId) {
                  ShowSnackBar.failureSnackBar(
                    context: context,
                    content: 'Owner is already a member',
                  );
                  return;
                }
                if (_selectedUserIds.contains(userId)) {
                  ShowSnackBar.failureSnackBar(
                    context: context,
                    content: 'User already selected',
                  );
                  return;
                }

                setState(() {
                  _selectedUserIds.add(userId);
                });
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


