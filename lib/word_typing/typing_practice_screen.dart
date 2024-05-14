import 'package:flutter/material.dart';
import 'package:english_flashcard/models/word_model.dart';

class TypingPracticeScreen extends StatefulWidget {
  final String topicId;
  final List<dynamic> wordList;

  const TypingPracticeScreen({
    Key? key,
    required this.topicId,
    required this.wordList,
  }) : super(key: key);

  @override
  _TypingPracticeScreenState createState() => _TypingPracticeScreenState();
}

class _TypingPracticeScreenState extends State<TypingPracticeScreen> {
  List<WordModel> myWordList = [];
  int index = 0;
  bool isCorrect = false;
  String? userInput;
  String? correctAnswer;
  bool showResult = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    initWordList();
  }

  void initWordList() {
    for (int i = 0; i < widget.wordList.length; i++) {
      WordModel myWord = widget.wordList[i].data();
      myWordList.add(myWord);
    }
    myWordList.shuffle();
  }

  void nextWord() {
    if (index == myWordList.length - 1) {
      Navigator.popUntil(context, ModalRoute.withName('/topic_detail'));
      return;
    }
    setState(() {
      index++;
      isCorrect = false;
      userInput = null;
      correctAnswer = null;
      showResult = false;
      _controller.clear();
    });
  }

  void checkAnswer(String input) {
    final currentWord = myWordList[index];
    final correct = currentWord.english.toLowerCase();
    setState(() {
      isCorrect = input.trim().toLowerCase() == correct;
      correctAnswer = correct;
    });
  }

  void submitAnswer() {
    setState(() {
      showResult = true;
      userInput = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = myWordList[index];
    final maxLength = currentWord.english.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Typing Practice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentWord.vietnamese,
              style: const TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter the English meaning',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                counterText: '${_controller.text.length}/$maxLength',
              ),
              textAlign: TextAlign.center,
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  checkAnswer(value);
                });
              },
              maxLength: maxLength,
            ),
            const SizedBox(height: 20.0),
            if (showResult)
              Text(
                correctAnswer ?? '',
                style: TextStyle(color: isCorrect ? Colors.green : Colors.red),
              ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: submitAnswer,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: nextWord,
              child: const Text('Next Word'),
            ),
          ],
        ),
      ),
    );
  }
}
