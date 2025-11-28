import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/services/local_storage_service.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseServices _firebaseServices = FirebaseServices();
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickAndUpload() async {
    final user = _firebaseServices.currentUser;
    if (user == null) return;

    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (file == null) return;

    setState(() => _isUploading = true);

    try {
      await _firebaseServices.uploadProfilePhoto(uid: user.uid, file: file);
      if (!mounted) return;
      ShowSnackBar.successSnackBar(
        context: context,
        content: 'Profile photo updated',
      );
    } catch (e) {
      if (!mounted) return;
      ShowSnackBar.failureSnackBar(
        context: context,
        content: 'Uploading photo failed: ${e.toString()}',
      );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _signOut() async {
    await _firebaseServices.signOut();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = _firebaseServices.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please sign in to view your profile.'),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _firebaseServices.userProfileStream(user.uid),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        final String name = data?['name'] ?? user.displayName ?? 'Guest';
        final String email = data?['email'] ?? user.email ?? 'No email';
        final String? photoUrl = data?['photoUrl'] as String?;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      children: [
                        FutureBuilder<File?>(
                          future: photoUrl != null && photoUrl!.startsWith('local:')
                              ? LocalStorageService.getProfilePhotoFile(
                                  photoUrl!.substring(6))
                              : Future.value(null),
                          builder: (context, snapshot) {
                            if (photoUrl != null && photoUrl!.startsWith('local:')) {
                              // Local photo
                              if (snapshot.hasData && snapshot.data != null) {
                                return CircleAvatar(
                                  radius: 60,
                                  backgroundColor: AppColors.lightGrey,
                                  backgroundImage: FileImage(snapshot.data!),
                                );
                              }
                              return CircleAvatar(
                                radius: 60,
                                backgroundColor: AppColors.lightGrey,
                                child: const Icon(
                                  Icons.person,
                                  size: 48,
                                  color: AppColors.grey,
                                ),
                              );
                            } else if (photoUrl != null && photoUrl!.isNotEmpty) {
                              // Network photo (backward compatibility)
                              return CircleAvatar(
                                radius: 60,
                                backgroundColor: AppColors.lightGrey,
                                backgroundImage: NetworkImage(photoUrl!),
                                onBackgroundImageError: (_, __) {},
                                child: const Icon(
                                  Icons.person,
                                  size: 48,
                                  color: AppColors.grey,
                                ),
                              );
                            } else {
                              // No photo
                              return CircleAvatar(
                                radius: 60,
                                backgroundColor: AppColors.lightGrey,
                                child: const Icon(
                                  Icons.person,
                                  size: 48,
                                  color: AppColors.grey,
                                ),
                              );
                            }
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: _isUploading ? null : _pickAndUpload,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.primaryColor,
                              child: _isUploading
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          AppColors.white,
                                        ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: AppColors.white,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 0,
                    color: AppColors.lightGrey.withValues(alpha: 0.4),
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Name'),
                      subtitle: Text(name),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 0,
                    color: AppColors.lightGrey.withValues(alpha: 0.4),
                    child: ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(email),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _signOut,
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

