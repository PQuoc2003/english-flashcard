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
        toFirestore: (folder, _) => folder.toJson());
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


  Future<void> createFolder(BuildContext context, FolderModel folderModel) async {
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

  Future<void> deleteFolder(BuildContext context, String folderId) async {
    await _folderRef.doc(folderId).delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Folder deleted successfully!'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed when deleting folder'),
        ),
      );
    });
  }


}
