import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/utils/app_styles.dart';
import 'package:final_project/core/utils/show_snack_bar.dart';
import 'package:flutter/material.dart';

import 'widgets/profile_avatar.dart';
import 'widgets/profile_info_section.dart';
import 'widgets/signout_button.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseServices _firebaseServices = FirebaseServices();
  bool _isUploading = false;

  Future<void> _pickAndUpload() async {
    final user = _firebaseServices.currentUser;
    if (user == null) return;

    final file = await _firebaseServices.pickProfileImage();
    if (file == null) return;

    setState(() => _isUploading = true);

    try {
      await _firebaseServices.uploadProfilePhoto(uid: user.uid, file: file);
      if (mounted) {
        ShowSnackBar.successSnackBar(
          context: context,
          content: 'Photo updated',
        );
      }
    } catch (e) {
      if (mounted) {
        ShowSnackBar.failureSnackBar(context: context, content: 'Failed: $e');
      }
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _signOut() {
    _firebaseServices.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = _firebaseServices.currentUser;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _firebaseServices.userProfileStream(user!.uid),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        final name = data?['name'] ?? 'Guest';
        final email = data?['email'] ?? 'No email';
        final photoUrl = data?['photoUrl'];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: Padding(
            padding: AppStyles.screenPadding,
            child: Column(
              children: [
                const SizedBox(height: 20),
                ProfileAvatar(
                  name: name,
                  photoUrl: photoUrl,
                  isUploading: _isUploading,
                  onPickImage: _pickAndUpload,
                ),
                const SizedBox(height: 40),
                ProfileInfoSection(name: name, email: email),
                const Spacer(),
                SignOutButton(onSignOut: _signOut),
              ],
            ),
          ),
        );
      },
    );
  }
}
