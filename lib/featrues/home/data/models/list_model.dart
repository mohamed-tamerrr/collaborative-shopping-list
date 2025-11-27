import 'package:cloud_firestore/cloud_firestore.dart';

class ListModel {
  final String id;
  final String name;
  final String ownerId;
  final List<String> members;
  final String? note;
  final String tag;
  final DateTime? createdAt;
  final bool pinned;

  ListModel({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.members,
    this.note,
    required this.tag,
    this.createdAt,
    this.pinned = false,
  });

  factory ListModel.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ListModel(
      id: doc.id,
      name: data['name'] ?? '',
      ownerId: data['ownerId'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      note: data['note'],
      tag: data['tag'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      pinned: data['pinned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ownerId': ownerId,
      'members': members,
      'note': note,
      'tag': tag,
      'pinned': pinned,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
