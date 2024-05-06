import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_flashcard/models/folder_model.dart';
import 'package:flutter/material.dart';

const String databaseName = "MyFolders";

class FolderRepository {

  final _db = FirebaseFirestore.instance;

  late final CollectionReference _folderRef;

  FolderRepository() {
    _folderRef = _db.collection(databaseName).withConverter<FolderModel>(
        fromFirestore: (snapshots, _) => FolderModel.fromJson(snapshots.data()!),
        toFirestore: (user, _) => user.toJson());
  }


  Stream<QuerySnapshot> getFolder() {
    return _folderRef.snapshots();
  }

  Stream<QuerySnapshot> getFolderByUserId(String uid) {
    return _folderRef.where('uid', isEqualTo: uid).snapshots();
  }


  void updateFolder(String docId, FolderModel folderModel){
    _folderRef.doc(docId).update(folderModel.toJson());
  }

  Future<void> createUser(BuildContext context, FolderModel folderModel) async {
    await _folderRef.add(folderModel).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Folder created successfully!'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed when created folder'),
        ),
      );
    });
  }
}
