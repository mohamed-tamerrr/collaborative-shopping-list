import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/local_storage_service.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MembersAvatarsRow extends StatelessWidget {
  const MembersAvatarsRow({super.key, required this.memberIds});

  final List<String> memberIds;

  Future<List<MemberInfo>> _fetchMembers() async {
    if (memberIds.isEmpty) return [];

    final firestore = FirebaseFirestore.instance;
    final docs = await Future.wait(
      memberIds.map((id) => firestore.collection('users').doc(id).get()),
    );

    return docs.map((doc) {
      if (!doc.exists) {
        return MemberInfo(uid: doc.id, email: 'Unknown', photoUrl: null);
      }
      final data = doc.data() ?? {};
      return MemberInfo(
        uid: doc.id,
        email: data['email'] ?? 'Unknown',
        photoUrl: data['photoUrl'] as String?,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (memberIds.isEmpty) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<List<MemberInfo>>(
      future: _fetchMembers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 60,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final members = snapshot.data ?? [];
        if (members.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: members.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final member = members[index];
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Email'),
                      content: Text(member.email),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: Column(
                  children: [
                    _MemberAvatar(
                      photoUrl: member.photoUrl,
                      email: member.email,
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 60,
                      child: Text(
                        member.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class MemberInfo {
  MemberInfo({required this.uid, required this.email, this.photoUrl});
  final String uid;
  final String email;
  final String? photoUrl;
}

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({required this.photoUrl, required this.email});
  final String? photoUrl;
  final String email;

  @override
  Widget build(BuildContext context) {
    final initials = email.isNotEmpty ? email[0].toUpperCase() : '?';

    if (photoUrl == null || photoUrl!.isEmpty) {
      return CircleAvatar(
        radius: 25,
        backgroundColor: AppColors.lightGrey,
        child: Text(
          initials,
          style: const TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (photoUrl!.startsWith('local:')) {
      final uid = photoUrl!.substring(6);
      return FutureBuilder<File?>(
        future: LocalStorageService.getProfilePhotoFile(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return CircleAvatar(
              radius: 25,
              backgroundImage: FileImage(snapshot.data!),
            );
          }
          return CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.lightGrey,
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      );
    }

    return CircleAvatar(
      radius: 25,
      backgroundImage: NetworkImage(photoUrl!),
      backgroundColor: AppColors.lightGrey,
      onBackgroundImageError: (_, __) {},
      child: Text(initials, style: const TextStyle(color: Colors.transparent)),
    );
  }
}
