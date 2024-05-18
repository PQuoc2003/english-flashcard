import 'package:cloud_firestore/cloud_firestore.dart';

class TopicModel {
  String topicName;
  String topicDescription;
  Timestamp createdDate;
  String folderId;
  String uid;
  int currLearningIndex;
  int numberOfWord;
  bool isPublic;

  TopicModel({
    required this.topicName,
    required this.topicDescription,
    required this.createdDate,
    required this.folderId,
    required this.uid,
    required this.currLearningIndex,
    required this.numberOfWord,
    required this.isPublic,
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
      "isPublic": isPublic,
    };
  }

  TopicModel.fromJson(Map<dynamic, Object?> json)
      : this(
          topicName: json['topicName']! as String,
          topicDescription: json['topicDescription']! as String,
          createdDate: json['createdDate']! as Timestamp,
          folderId: json['folderId']! as String,
          uid: json['uid']! as String,
          currLearningIndex: json['currLearningIndex']! as int,
          numberOfWord: json['numberOfWord']! as int,
          isPublic: json['isPublic'] != null ? json['isPublic'] as bool : true ,
        );

  TopicModel copyWith({
    String? topicName,
    String? topicDescription,
    Timestamp? createdDate,
    String? folderId,
    String? uid,
    int? currLearningIndex,
    int? numberOfWord,
    bool? isPublic,
  }) {
    return TopicModel(
      topicName: topicName ?? this.topicName,
      topicDescription: topicDescription ?? this.topicDescription,
      createdDate: createdDate ?? this.createdDate,
      folderId: folderId ?? this.folderId,
      uid: uid ?? this.uid,
      currLearningIndex: currLearningIndex ?? this.currLearningIndex,
      numberOfWord: numberOfWord ?? this.numberOfWord,
      isPublic: isPublic ?? this.isPublic,
    );
  }
}
