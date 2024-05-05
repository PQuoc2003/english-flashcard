import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  final String id;
  final String name;
  final bool isPublic;
  final List<Word> words;
  final DateTime createdAt;

  Topic({
    required this.id,
    required this.name,
    required this.isPublic,
    required this.words,
    required this.createdAt,
  });

  static String getStringOrDefault(dynamic value) {
    return value is String ? value : '';
  }

  factory Topic.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    List<Word> words = [];
    if (data['words'] != null) {
      List<dynamic> wordList = data['words'];
      words = wordList.map((word) => Word.fromMap(word)).toList();
    }

    return Topic(
      id: doc.id,
      name: getStringOrDefault(data["name"]),
      isPublic: data['isPublic'] ?? false,
      words: words,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isPublic': isPublic,
      'words': words.map((word) => word.toMap()).toList(),
      'createdAt': createdAt,
    };
  }
}

class Word {
  final String english;
  final String vietnamese;

  Word({required this.english, required this.vietnamese});

  static String getStringOrDefault(dynamic value) {
    return value is String ? value : '';
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      english: getStringOrDefault(map['english']),
      vietnamese: getStringOrDefault(map['vietnamese']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'english': english,
      'vietnamese': vietnamese,
    };
  }
}
