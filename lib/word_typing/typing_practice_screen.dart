import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:english_flashcard/models/word_model.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TypingPracticeScreen extends StatefulWidget {
  final String topicId;
  final List<dynamic> wordList;

  const TypingPracticeScreen({
    super.key,
    required this.topicId,
    required this.wordList,
  });

  @override
  State<TypingPracticeScreen> createState() => _TypingPracticeScreenState();
}

class _TypingPracticeScreenState extends State<TypingPracticeScreen> {
  List<WordModel> myWordList = [];
  int index = 0;
  bool isCorrect = false;
  String? userInput;
  String? correctAnswer;
  bool showResult = false;
  late TextEditingController _controller;
  int correctCount = 0;
  int totalCount = 0;
  final FlutterTts flutterTts = FlutterTts();
  bool submitted = false;

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

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  void nextWord() {
    if (!submitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please submit your answer first.'),
        ),
      );
      return;
    }
    else {
      if (index == myWordList.length - 1) {
        showScore();
        return;
      }
      setState(() {
        index++;
        isCorrect = false;
        userInput = null;
        correctAnswer = null;
        showResult = false;
        _controller.clear();
        submitted = false;
      });
    }
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
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please input your answer.'),
        ),
      );
      return;
    }

    setState(() {
      showResult = true;
      userInput = _controller.text;
      if (isCorrect) {
        correctCount++;
      }
      totalCount++;
      submitted = true;
    });
  }


  void showScore() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Practice Finished'),
          content: Text(
            'Your Score: $correctCount / $totalCount',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(fontSize: 16.0)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = myWordList[index];
    final maxLength = currentWord.english.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Typing Practice',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Type the English meaning of:',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              currentWord.vietnamese,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    speak(currentWord.english);
                  },
                  child: const Icon(Icons.volume_up),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            CupertinoTextField(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8.0),
              ),
              placeholder: 'Enter your answer',
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
                isCorrect ? 'Correct!' : 'Incorrect. The correct answer is: $correctAnswer',
                style: TextStyle(color: isCorrect ? Colors.green : Colors.red, fontSize: 18.0),
              ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  onPressed: submitAnswer,
                  color: Colors.blue,
                  child: const Text('Submit', style: TextStyle(fontSize: 16.0)),
                ),
                const SizedBox(width: 20.0),
                CupertinoButton(
                  onPressed: nextWord,
                  color: Colors.blue,
                  child: const Text('Next Word', style: TextStyle(fontSize: 16.0)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
