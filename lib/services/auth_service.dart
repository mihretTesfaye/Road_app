import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    // Create auth user first
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user!;
    // create user document in Firestore. If Firestore write fails, rollback auth user.
    final userDoc = AppUser(
      uid: user.uid,
      name: name,
      email: user.email ?? email,
      phone: null,
    );

    try {
      await _firestore.collection('users').doc(user.uid).set(userDoc.toMap());
    } catch (e) {
      // attempt to delete the created auth user to avoid orphaned accounts
      try {
        await user.delete();
      } catch (_) {
        // ignore deletion errors
      }
      rethrow;
    }

    return cred;
  }

  Future<UserCredential> signIn({required String email, required String password}) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();

  Future<AppUser?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.data()!);
  }
}
