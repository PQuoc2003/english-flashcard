import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_flashcard/models/topic_model.dart';
import 'package:flutter/material.dart';

const String databaseName = "MyTopics";

class TopicRepository {
  final _db = FirebaseFirestore.instance;

  late final CollectionReference _topicRef;

  TopicRepository() {
    _topicRef = _db.collection(databaseName).withConverter<TopicModel>(
        fromFirestore: (snapshots, _) => TopicModel.fromJson(snapshots.data()!),
        toFirestore: (topic, _) => topic.toJson());
  }

  Stream<QuerySnapshot> getTopic() {
    return _topicRef.snapshots();
  }

  Stream<QuerySnapshot> getTopicByFolderId(String folderId) {
    return _topicRef.where('folderId', isEqualTo: folderId).snapshots();
  }

  Stream<QuerySnapshot> getTopicByUserId(String uid) {
    return _topicRef
        .where('uid', isEqualTo: uid)
        // .orderBy("topicName", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getTopicByUidAndCreatedDate(
      String uid, Timestamp createdDate) {
    return _topicRef
        .where('uid', isEqualTo: uid)
        .where('createdDate', isEqualTo: createdDate)
        .snapshots();
  }

  Future<String> getTopicIdByUidAndCreatedDate(
      String uid, Timestamp createdDate) async {
    QuerySnapshot snapshot = await _topicRef
        .where('uid', isEqualTo: uid)
        .where('createdDate', isEqualTo: createdDate)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs[0].id;
    }

    return '';
  }

  Stream<DocumentSnapshot> getTopicById(String topicId) {
    return _topicRef.doc(topicId).snapshots();
  }

  Stream<QuerySnapshot> getPublicTopicByTopicName(String topicName) {
    return _topicRef
        .where('topicName', isEqualTo: topicName)
        .where("isPublic", isEqualTo: true)
        .snapshots();
  }

  void updateTopic(String docId, TopicModel topicModel) {
    _topicRef.doc(docId).update(topicModel.toJson());
  }

  Future<void> createTopic(BuildContext context, TopicModel topicModel) async {
    await _topicRef.add(topicModel).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Topic created successfully!'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed when created topic'),
        ),
      );
    });
  }

  Future<void> deleteTopic(BuildContext context, String topicId) async {
    await _topicRef.doc(topicId).delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Topic deleted successfully!'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed when deleting topic'),
        ),
      );
    });
  }
}
