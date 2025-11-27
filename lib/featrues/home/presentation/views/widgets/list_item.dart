import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/firebase_services.dart';
import 'package:final_project/core/utils/app_images.dart';
import 'package:final_project/featrues/home/data/models/list_model.dart';
import 'package:final_project/featrues/home/presentation/view_model/list_cubit/list_cubit.dart';
import 'package:final_project/featrues/home/presentation/views/items_view.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/group_avatar.dart';
import 'package:final_project/featrues/home/presentation/views/widgets/list_item_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.listModel, required this.listId});

  final ListModel listModel;
  final String listId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ListCubit>().currentListId = listId;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ItemsView(
              listModel: listModel,
              listId: listId,
              tagName: listModel.tag,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffEAECF0), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 24,
            right: 10,
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    listModel.name.length >= 25
                        ? listModel.name.substring(0, 25)
                        : listModel.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () async {
                      await context.read<ListCubit>().togglePin(
                        listId,
                        listModel.pinned,
                      );
                    },
                    icon: Icon(
                      listModel.pinned
                          ? Icons.push_pin
                          : Icons.push_pin_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
                future: _getMembersData(listModel.members),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 35,
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  }

                  final photoUrls = <String?>[];
                  if (snapshot.hasData && snapshot.data != null) {
                    for (var memberDoc in snapshot.data!) {
                      if (memberDoc.exists) {
                        final data = memberDoc.data();
                        photoUrls.add(data?['photoUrl'] as String?);
                      } else {
                        photoUrls.add(null);
                      }
                    }
                  }

                  // If no data, create list with nulls for all members
                  if (photoUrls.isEmpty && listModel.members.isNotEmpty) {
                    photoUrls.addAll(List.filled(listModel.members.length, null));
                  }

                  return GroupAvatars(
                    imageUrls: photoUrls,
                  );
                },
              ),

              const SizedBox(height: 8),

              StreamBuilder(
                stream: context.read<ListCubit>().itemsCountStream(listId),
                builder: (context, snapshot) {
                  int completed = 0;
                  int total = 0;

                  if (snapshot.hasData) {
                    completed = snapshot.data!['completed']!;
                    total = snapshot.data!['total']!;
                  }

                  return ListItemInfo(
                    itemslength: total,
                    doneItemslength: completed,
                    tagName: listModel.tag,
                  );
                },
              ),
            ],
          ),
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
