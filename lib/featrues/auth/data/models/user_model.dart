import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String uid;
  String email;
  String? name;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  AppUser({this.createdAt, this.updatedAt, required this.uid, required this.email, this.name});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };

  }

  factory AppUser.fromMap(Map<String, dynamic> map) {

    return AppUser(
      createdAt:map['createdAt'] as Timestamp?,
      updatedAt:map['updatedAt'] as Timestamp?,
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,

    );
  }
}
