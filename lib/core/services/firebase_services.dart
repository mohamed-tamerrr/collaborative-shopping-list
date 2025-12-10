import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/core/services/local_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseServices {
  FirebaseServices();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickProfileImage() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      return file;
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user?.updateDisplayName(name);

    await _firestore.collection('users').doc(credential.user!.uid).set({
      'name': name,
      'email': email,
      'photoUrl': credential.user?.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();

  Stream<DocumentSnapshot<Map<String, dynamic>>> userProfileStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  Future<void> updateDisplayName({
    required String uid,
    required String name,
  }) async {
    await _firestore.collection('users').doc(uid).update({'name': name});
    await _auth.currentUser?.updateDisplayName(name);
  }

  Future<String?> uploadProfilePhoto({
    required String uid,
    required XFile file,
  }) async {
    try {
      final Uint8List bytes = await file.readAsBytes();

      // Get file extension properly
      String extension = file.name.split('.').last.toLowerCase();
      if (extension.isEmpty || !RegExp(r'^[a-z0-9]+$').hasMatch(extension)) {
        extension = 'jpg'; // Default to jpg if extension is invalid
      }

      // Save photo locally
      final localPath = await LocalStorageService.saveProfilePhoto(
        uid: uid,
        bytes: bytes,
        extension: extension,
      );

      // Store indicator in Firestore that photo is stored locally

      await _firestore.collection('users').doc(uid).update({
        'photoUrl': 'local:$uid', // Store indicator, not the full path
        'hasLocalPhoto': true,
      });

      // Update auth profile (optional, can be null)
      await _auth.currentUser?.updatePhotoURL(null);

      return localPath;
    } catch (e) {
      // Check if it's a MissingPluginException
      if (e.toString().contains('MissingPluginException')) {
        throw Exception(
          'Please restart the app completely (stop and run again) to enable photo storage.',
        );
      }
      throw Exception('Failed to save photo: $e');
    }
  }

  // Get local photo file path for a user
  Future<String?> getLocalPhotoPath(String uid) async {
    try {
      final file = await LocalStorageService.getProfilePhotoFile(uid);
      return file?.path;
    } catch (e) {
      return null;
    }
  }

  // Get all users from Firebase
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return _firestore.collection('users').snapshots();
  }

  // Get user by email
  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserByEmail(
    String email,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get user by UID
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserByUid(
    String uid,
  ) async {
    return await _firestore.collection('users').doc(uid).get();
  }
}
