class WordModel {
  String english;
  String vietnamese;
  bool isLearned;
  String topicId;

  WordModel({
    required this.english,
    required this.vietnamese,
    required this.isLearned,
    required this.topicId,
  });

  toJson() {
    return {
      "english": english,
      "vietnamese": vietnamese,
      "isLearned": isLearned,
      "topicId": topicId,
    };
  }

  WordModel.fromJson(Map<dynamic, Object?> json)
      : this(
    english: json['english']! as String,
    vietnamese: json['vietnamese']! as String,
    isLearned: json['isLearned']! as bool,
    topicId: json['topicId']! as String,
  );

  WordModel copyWith({
    String? english,
    String? vietnamese,
    bool? isLearned,
    String? topicId,
  }) {
    return WordModel(
      english: english ?? this.english,
      vietnamese: vietnamese ?? this.vietnamese,
      isLearned: isLearned ?? this.isLearned,
      topicId: topicId ?? this.topicId,
    );
  }


}
