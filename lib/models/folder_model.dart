import 'package:cloud_firestore/cloud_firestore.dart';

class FolderModel {
  String folderId;
  String folderName;
  String folderDes;
  Timestamp folderCreated;
  bool folderIsPublic;
  int numberOfTopic;
  String uid;

  FolderModel({
    required this.folderId,
    required this.folderName,
    required this.folderDes,
    required this.folderCreated,
    required this.folderIsPublic,
    required this.numberOfTopic,
    required this.uid,
  });

  toJson() {
    return {
      "folderId": folderId,
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
          folderId: json['folderId']! as String,
          folderName: json['folderName']! as String,
          folderDes: json['folderDes']! as String,
          folderCreated: json['folderCreated']! as Timestamp,
          folderIsPublic: json['folderIsPublic']! as bool,
          numberOfTopic: json['numberOfTopic']! as int,
          uid: json['uid']! as String,
        );

  FolderModel copyWith({
    String? folderId,
    String? folderName,
    String? folderDes,
    Timestamp? folderCreated,
    bool? folderIsPublic,
    int? numberOfTopic,
    String? uid,
  }) {
    return FolderModel(
      folderId: folderId ?? this.folderId,
      folderName: folderName ?? this.folderName,
      folderDes: folderDes ?? this.folderDes,
      folderCreated: folderCreated ?? this.folderCreated,
      folderIsPublic: folderIsPublic ?? this.folderIsPublic,
      numberOfTopic: numberOfTopic ?? this.numberOfTopic,
      uid: uid ?? this.uid,
    );
  }
}
