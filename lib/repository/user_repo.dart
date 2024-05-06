import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_flashcard/models/users_model.dart';
import 'package:flutter/material.dart';

const String databaseName = "MyUsers";

class UserRepository {
  final _db = FirebaseFirestore.instance;

  late final CollectionReference _userRef;

  UserRepository() {
    _userRef = _db.collection(databaseName).withConverter<UserModel>(
        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
        toFirestore: (user, _) => user.toJson());
  }


  Stream<QuerySnapshot> getUser() {
    return _userRef.snapshots();
  }

  Stream<QuerySnapshot> getUsersByName(String name) {
    return _userRef.where('fullName', isEqualTo: name).snapshots();
  }


  void updateUser(String uid, UserModel userModel){
    _userRef.doc(uid).update(userModel.toJson());
  }

  Future<void> createUser(BuildContext context, UserModel userModel) async {
    await _userRef.add(userModel).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User created successfully!'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed when created user'),
        ),
      );
    });
  }
}
