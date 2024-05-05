class Topic {
  String id;
  String name;
  bool isPublic;
  List<Word> words;
  DateTime createdAt;

  Topic({
    required this.id,
    required this.name,
    required this.isPublic,
    required this.words,
    required this.createdAt,
  });
}

// folder.dart
class Folder {
  String id;
  String name;
  List<Topic> topics;

  Folder({
    required this.id,
    required this.name,
    required this.topics,
  });
}

// word.dart
class Word {
  String english;
  String vietnamese;
  WordStatus status;

  Word({
    required this.english,
    required this.vietnamese,
    required this.status,
  });
}

enum WordStatus {
  NotLearned,
  CurrentlyLearning,
  Mastered,
}
