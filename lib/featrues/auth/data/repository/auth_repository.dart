import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/featrues/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // get current firebase user
  User? get firebaseUser => _auth.currentUser;

  Future<AppUser?> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) return null;
      final appUser = AppUser(
        uid: user.uid,
        email: user.email ?? '',
        name: name ?? '',
      );
      await _fireStore.collection('users').doc(user.uid).set({
        ...appUser.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }
    );
      await user.sendEmailVerification();
      return appUser;
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException in signUp:  ${e.message}');
      return null;

    } on FirebaseException catch(e)
    {
      log('FirebaseException in signUp:  ${e.message}');
      return null;
    } catch(e)
    {
      log('Error in signUp: $e');
      return null;
    }

  }

  Future<AppUser?> logIn({
    required String email,
    required String password,
  }) async {
    try{
      final userCredentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredentials.user;
      if (user == null) return null;
      await _fireStore.collection('users').doc(user.uid).set({
        'updatedAt': FieldValue.serverTimestamp(),
      },SetOptions(merge: true));

      final doc = await _fireStore.collection('users').doc(user.uid).get();
      if (doc.exists&& doc.data()!=null) {
        return AppUser.fromMap(doc.data()!);
      }
      return AppUser(uid: user.uid, email: user.email ?? '');

    }on FirebaseAuthException catch(e)
    {
      log('FirebaseAuthException in signUp:  ${e.message}');
      return null;
    }
    on FirebaseException catch(e)
    {
      log('FirebaseException in signUp:  ${e.message}');
      return null;
    } catch(e)
    {
      log('Error in signUp: $e');
      return null;
    }
  }
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logOut() async {
    try{
      await _auth.signOut();
    }catch(e)
    {
      log('Error in logOut: $e');

    }

  }

  Future<AppUser?> getUserById(String uid) async {
    try {
      final doc = await _fireStore.collection('users').doc(uid).get();
      if (!doc.exists || doc.data() == null) return null;
      return AppUser.fromMap(doc.data()!);
    }on FirebaseException catch (e) {
      log('FirebaseException in getUserById: ${e.message}');
      return null;

    } catch(e){
      log('Error in getUserById: $e');
      return null;
    }
  }
}
