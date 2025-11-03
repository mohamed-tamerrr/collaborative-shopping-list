import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String name;
  final String addedBy;
  bool done;
  final DateTime? createdAt;

  ItemModel({
    required this.id,
    required this.name,
    required this.addedBy,
    required this.done,
    this.createdAt,
  });

  factory ItemModel.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ItemModel(
      id: doc.id,
      name: data['name'] ?? '',
      addedBy: data['addedBy'] ?? '',
      done: data['done'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'addedBy': addedBy,
      'done': done,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
