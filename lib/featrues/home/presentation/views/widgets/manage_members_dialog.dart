import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/user_avatar.dart';
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
  // Store displayed user info: {uid, email, name, photoUrl}
  List<Map<String, dynamic>> _displayedUsers = [];
  bool _isSaving = false;
  late Future<List<Map<String, dynamic>>> _membersFuture;

  @override
  void initState() {
    super.initState();
    // Initialize selected IDs with current members (excluding owner)
    _selectedUserIds = widget.currentMembers
        .where((id) => id != widget.ownerId)
        .toSet();
    _membersFuture = _fetchMemberDetails();
  }

  Future<List<Map<String, dynamic>>> _fetchMemberDetails() async {
    final futures = _selectedUserIds.map((userId) {
      return FirebaseFirestore.instance.collection('users').doc(userId).get();
    });

    final snapshots = await Future.wait(futures);
    List<Map<String, dynamic>> loadedUsers = [];

    for (var doc in snapshots) {
      if (doc.exists) {
        final data = doc.data();
        loadedUsers.add({
          'uid': doc.id,
          'email': data?['email'] ?? 'Unknown',
          'name': data?['name'] ?? 'Unknown',
          'photoUrl': data?['photoUrl'],
        });
      }
    }

    _displayedUsers = loadedUsers;
    return _displayedUsers;
  }

  @override
  Widget build(BuildContext context) {
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
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _membersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error loading members: ${snapshot.error}'),
              );
            }

            // Let's rely on _displayedUsers list which we update.
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: _showAddEmailDialog,
                        icon: const Icon(Icons.add),
                        label: const Text("Add User"),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: _displayedUsers.isEmpty
                      ? const Center(child: Text("No members in this list."))
                      : ListView.builder(
                          itemCount: _displayedUsers.length,
                          itemBuilder: (context, index) {
                            final user = _displayedUsers[index];
                            final userId = user['uid'] as String;
                            final email = user['email'] as String;
                            final name = user['name'] as String;
                            final photoUrl = user['photoUrl'] as String?;

                            return ListTile(
                              leading: UserAvatar(
                                name: name,
                                photoUrl: photoUrl,
                                radius: 20,
                              ),
                              title: Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                email,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _selectedUserIds.remove(userId);
                                    _displayedUsers.removeAt(index);
                                  });
                                },
                              ),
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

      final toAdd = _selectedUserIds
          .where((id) => !members.contains(id))
          .toList();
      final toRemove = members
          .where((id) => id != widget.ownerId && !_selectedUserIds.contains(id))
          .toList();

      for (final userId in toAdd) {
        if (mounted) {
          await listCubit.inviteUser(
            listId: widget.listId,
            userId: userId,
            context: context,
          );
        }
      }

      for (final userId in toRemove) {
        if (mounted) {
          await listCubit.removeUser(
            listId: widget.listId,
            userId: userId,
            context: context,
          );
        }
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
              if (!context.mounted) return;
              if (userDoc != null && userDoc.exists) {
                final userId = userDoc.id;
                final data = userDoc.data();
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
                  _displayedUsers.add({
                    'uid': userId,
                    'email': email,
                    'name': data?['name'] ?? 'Unknown',
                    'photoUrl': data?['photoUrl'],
                  });
                });
                if (context.mounted) {
                  Navigator.pop(context);
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
