import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_flashcard/models/word_model.dart';
import 'package:flutter/material.dart';

const String databaseName = "MyWords";

class WordRepository {

  final _db = FirebaseFirestore.instance;

  late final CollectionReference _wordRef;

  WordRepository() {
    _wordRef = _db.collection(databaseName).withConverter<WordModel>(
        fromFirestore: (snapshots, _) => WordModel.fromJson(snapshots.data()!),
        toFirestore: (word, _) => word.toJson());
  }

  Stream<QuerySnapshot> getWord() {
    return _wordRef.snapshots();
  }

  Stream<QuerySnapshot> getWordByTopicId(String topicId) {
    return _wordRef.where('topicId', isEqualTo: topicId).snapshots();
  }


  void updateWord(String docId, WordModel wordModel){
    _wordRef.doc(docId).update(wordModel.toJson());
  }

  Future<void> addWord(BuildContext context, WordModel wordModel) async {
    await _wordRef.add(wordModel).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Word added successfully!'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed when added word'),
        ),
      );
    });
  }

  Future<void> deleteWord(BuildContext context, String wordId) async {
    await _wordRef.doc(wordId).delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Word deleted successfully!'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed when deleting word'),
        ),
      );
    });
  }



}
