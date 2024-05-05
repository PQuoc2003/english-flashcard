import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String displayName;
  final DateTime createdAt;

  User({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
  });

  static String getStringOrDefault(dynamic value) {
    return value is String ? value : '';
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return User(
      uid: doc.id,
      email: getStringOrDefault(data["email"]),
      displayName: getStringOrDefault(data["displayName"]),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt,
    };
  }
}
