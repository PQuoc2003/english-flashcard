class UserModel {
  String uid;
  String fullName;
  String gender;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.gender,
  });

  toJson() {
    return {
      "uid": uid,
      "fullName": fullName,
      "gender": gender,
    };
  }

  UserModel.fromJson(Map<String, Object?> json)
      : this(
          uid: json['uid']! as String,
          fullName: json['fullName']! as String,
          gender: json['gender']! as String,
        );
}
