class WordModel {
  int index;
  String english;
  String vietnamese;
  bool isLearned;
  String topicId;

  WordModel({
    required this.index,
    required this.english,
    required this.vietnamese,
    required this.isLearned,
    required this.topicId,
  });

  toJson() {
    return {
      "index": index,
      "english": english,
      "vietnamese": vietnamese,
      "isLearned": isLearned,
      "topicId": topicId,
    };
  }

  WordModel.fromJson(Map<dynamic, Object?> json)
      : this(
    index: json['index']! as int,
    english: json['english']! as String,
    vietnamese: json['vietnamese']! as String,
    isLearned: json['isLearned']! as bool,
    topicId: json['topicId']! as String,
  );

  WordModel copyWith({
    int? index,
    String? english,
    String? vietnamese,
    bool? isLearned,
    String? topicId,
  }) {
    return WordModel(
      index: index ?? this.index,
      english: english ?? this.english,
      vietnamese: vietnamese ?? this.vietnamese,
      isLearned: isLearned ?? this.isLearned,
      topicId: topicId ?? this.topicId,
    );
  }




}
