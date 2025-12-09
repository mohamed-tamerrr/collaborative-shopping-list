import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_styles.dart';
import 'package:final_project/featrues/home/data/models/list_model.dart';
import 'package:final_project/featrues/home/presentation/view_model/items_cubit/items_cubit.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/group_avatar.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/items_view_appbar.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/items_view_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsViewBody extends StatefulWidget {
  const ItemsViewBody({
    super.key,
    required this.listModel,
    required this.tagName,
  });

  final ListModel listModel;
  final String tagName;

  @override
  State<ItemsViewBody> createState() => _ItemsViewBodyState();
}

class _ItemsViewBodyState extends State<ItemsViewBody> {
  late String currentName;

  @override
  void initState() {
    super.initState();
    context.read<ItemsCubit>().listenToItems(
      context.read<ListCubit>().currentListId!,
    );
    currentName = widget.listModel.name;
  }

  void updateName(String name) {
    setState(() {
      currentName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppStyles.screenPaddingHorizontal,
        child: Column(
          children: [
            ItemsViewAppBar(
              currentName: currentName,
              listModel: widget.listModel,
              onRename: updateName,
            ),
            const SizedBox(height: AppStyles.spacingM),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('lists')
                  .doc(widget.listModel.id)
                  .snapshots(),
              builder: (context, listSnapshot) {
                if (!listSnapshot.hasData || !listSnapshot.data!.exists) {
                  return const SizedBox.shrink();
                }

                final members =
                    List<String>.from(listSnapshot.data!.data()?['members'] ?? []);

                return FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
                  future: _getMembersData(members),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 35,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.orange,
                            ),
                          ),
                        ),
                      );
                    }

                    final photoUrls = <String?>[];
                    final emails = <String>[];

                    if (snapshot.hasData && snapshot.data != null) {
                      for (var memberDoc in snapshot.data!) {
                        if (memberDoc.exists) {
                          final data = memberDoc.data();
                          photoUrls.add(data?['photoUrl'] as String?);
                          emails.add(data?['email'] ?? 'Unknown');
                        } else {
                          photoUrls.add(null);
                          emails.add('Unknown');
                        }
                      }
                    }

                    if (photoUrls.isEmpty && members.isNotEmpty) {
                      photoUrls.addAll(List.filled(members.length, null));
                      emails.addAll(List.filled(members.length, 'Unknown'));
                    }

                    return GroupAvatars(
                      imageUrls: photoUrls,
                      memberEmails: emails,
                      onAvatarTap: (email) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Email'),
                            content: Text(email),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: AppStyles.spacingM),
            Expanded(child: ItemsViewContent(tagName: widget.tagName)),
          ],
        ),
      ),
    );
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> _getMembersData(
    List<String> memberIds,
  ) async {
    if (memberIds.isEmpty) {
      return [];
    }

    final firestore = FirebaseFirestore.instance;

    // Get all member documents
    try {
      final docs = await Future.wait(
        memberIds.map((memberId) async {
          try {
            return await firestore.collection('users').doc(memberId).get();
          } catch (e) {
            // Return a document that doesn't exist if fetch fails
            return firestore.collection('users').doc('dummy').get();
          }
        }),
      );
      return docs;
    } catch (e) {
      return [];
    }
  }
}
