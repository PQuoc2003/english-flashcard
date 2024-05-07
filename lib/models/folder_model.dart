import 'package:cloud_firestore/cloud_firestore.dart';

class FolderModel {
  String folderName;
  String folderDes;
  Timestamp folderCreated;
  bool folderIsPublic;
  int numberOfTopic;
  String uid;

  FolderModel({
    required this.folderName,
    required this.folderDes,
    required this.folderCreated,
    required this.folderIsPublic,
    required this.numberOfTopic,
    required this.uid,
  });

  toJson() {
    return {
      "folderName": folderName,
      "folderDes": folderDes,
      "folderCreated": folderCreated,
      "folderIsPublic": folderIsPublic,
      "numberOfTopic": numberOfTopic,
      "uid": uid,
    };
  }

  FolderModel.fromJson(Map<dynamic, Object?> json)
      : this(
          folderName: json['folderName']! as String,
          folderDes: json['folderDes']! as String,
          folderCreated: json['folderCreated']! as Timestamp,
          folderIsPublic: json['folderIsPublic']! as bool,
          numberOfTopic: json['numberOfTopic']! as int,
          uid: json['uid']! as String,
        );

  FolderModel copyWith({
    String? folderName,
    String? folderDes,
    Timestamp? folderCreated,
    bool? folderIsPublic,
    int? numberOfTopic,
    String? uid,
  }) {
    return FolderModel(
      folderName: folderName ?? this.folderName,
      folderDes: folderDes ?? this.folderDes,
      folderCreated: folderCreated ?? this.folderCreated,
      folderIsPublic: folderIsPublic ?? this.folderIsPublic,
      numberOfTopic: numberOfTopic ?? this.numberOfTopic,
      uid: uid ?? this.uid,
    );
  }
}
