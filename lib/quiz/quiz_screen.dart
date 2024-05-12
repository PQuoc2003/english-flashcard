import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String topicId;

  const QuizScreen({
    super.key,
    required this.topicId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
      ),
    );
  }
}
