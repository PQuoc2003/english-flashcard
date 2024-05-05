import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    DateTime now = DateTime.now();

    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'email': email,
      'displayName': displayName,
      'createdAt': now,
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<User?> currentUserAsync() async {
    await Future.delayed(const Duration(seconds: 1));
    return _firebaseAuth.currentUser;
  }
}
