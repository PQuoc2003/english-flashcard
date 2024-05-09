import 'package:cloud_firestore/cloud_firestore.dart';

class TopicModel {
  String topicName;
  String topicDescription;
  Timestamp createdDate;
  String folderId;
  String uid;
  int currLearningIndex;
  int numberOfWord;

  TopicModel({
    required this.topicName,
    required this.topicDescription,
    required this.createdDate,
    required this.folderId,
    required this.uid,
    required this.currLearningIndex,
    required this.numberOfWord,
  });

  toJson() {
    return {
      "topicName": topicName,
      "topicDescription": topicDescription,
      "createdDate": createdDate,
      "folderId": folderId,
      "uid": uid,
      "currLearningIndex": currLearningIndex,
      "numberOfWord": numberOfWord,
    };
  }

  TopicModel.fromJson(Map<dynamic, Object?> json)
      : this(
          topicName: json['topicName']! as String,
          topicDescription: json['topicDescription']! as String,
          createdDate: json['folderCreated']! as Timestamp,
          folderId: json['folderId']! as String,
          uid: json['numberOfTopic']! as String,
          currLearningIndex: json['currLearningIndex']! as int,
          numberOfWord: json['numberOfWord']! as int,
        );

  TopicModel copyWith({
    String? topicName,
    String? topicDescription,
    Timestamp? createdDate,
    String? folderId,
    String? uid,
    int? currLearningIndex,
    int? numberOfWord,
  }) {
    return TopicModel(
      topicName: topicName ?? this.topicName,
      topicDescription: topicDescription ?? this.topicDescription,
      createdDate: createdDate ?? this.createdDate,
      folderId: folderId ?? this.folderId,
      uid: uid ?? this.uid,
      currLearningIndex: currLearningIndex ?? this.currLearningIndex,
      numberOfWord: numberOfWord ?? this.numberOfWord,
    );
  }
}
