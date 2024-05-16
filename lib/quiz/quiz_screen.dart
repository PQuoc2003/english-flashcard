import 'dart:math';

import 'package:english_flashcard/quiz/next_btn_quiz.dart';
import 'package:english_flashcard/quiz/option_card.dart';
import 'package:english_flashcard/quiz/question_widget.dart';
import 'package:english_flashcard/models/quiz/question_model.dart';
import 'package:english_flashcard/models/word_model.dart';
import 'package:english_flashcard/quiz/result_quiz.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String topicId;
  final List wordList;

  const QuizScreen({
    super.key,
    required this.topicId,
    required this.wordList,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<WordModel> myWordList = [];

  List<MyQuizQuestion> questionList = [];

  int index = 0;

  bool isPressed = false;

  int score = 0;


  @override
  void initState() {
    super.initState();
    initQuestionList();
  }

  void initQuestionList() {
    for (int i = 0; i < widget.wordList.length; i++) {
      WordModel myWord = widget.wordList[i].data();
      myWordList.add(myWord);
    }

    List<MyQuizQuestion> questionList = [];

    int numberOfOption = 4;

    List<String> englishList = [];

    List<String> vietnameseList = [];

    List<String> optionsList = [];

    for (WordModel word in myWordList) {
      englishList.add(word.english);
      vietnameseList.add(word.vietnamese);
      optionsList.add(word.english);
      optionsList.add(word.vietnamese);
    }

    if (myWordList.length < 3) {
      numberOfOption = 2;
    }

    for (int i = 0; i < myWordList.length * 2; i++) {
      Map<String, bool> options = {};

      String question = optionsList[i];

      String answer = "";

      if (i % 2 == 0) {
        answer = optionsList[i + 1];
      } else {
        answer = optionsList[i - 1];
      }

      options[answer] = true;

      List<String> cloneList = List.from(optionsList);

      cloneList.remove(question);
      cloneList.remove(answer);

      cloneList.shuffle(Random());

      for (int i = 0; i < numberOfOption - 1; i++) {
        options[cloneList[i]] = false;
      }

      // shuffle options
      List<String> keys = options.keys.toList();

      keys.shuffle(Random());

      Map<String, bool> shuffledOptions = {};
      for (String key in keys) {
        shuffledOptions[key] = options[key]!;
      }

      MyQuizQuestion myQuizQuestion =
          MyQuizQuestion(id: i, question: question, options: shuffledOptions);
      questionList.add(myQuizQuestion);
    }

    questionList.shuffle(Random());

    this.questionList = questionList;
  }


  void startOver() {
    setState(() {
      index = 0;
      isPressed = false;
      score = 0;
      myWordList = [];
      questionList = [];
      initQuestionList();
    });
    Navigator.pop(context);
  }

  void nextQuestion() {
    if (index == questionList.length - 1) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => QuizResult(
          score: score,
          totalScore: questionList.length,
          startOver: startOver,
        ),
      );
      return;
    }
    if (isPressed) {
      setState(() {
        index++;
        isPressed = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select any option to continue"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(20),
        ),
      );
    }
  }

  void checkAnswerAndUpdate(bool value) {
    if (value && !isPressed) {
      score++;
    }
    setState(() {
      isPressed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Text(
              "Score: $score", // Display user's score in the app bar
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              QuestionWidget( // Display the current question
                question: questionList[index].question,
                indexAction: index,
                totalQuestion: questionList.length,
              ),
              const Divider(color: Colors.white),
              SizedBox(height: 20),
              for (int i = 0; i < questionList[index].options.length; i++)
                GestureDetector(
                  onTap: () => checkAnswerAndUpdate(
                    questionList[index].options.values.toList()[i],
                  ),
                  child: OptionCard(
                    option: questionList[index].options.keys.toList()[i],
                    color: isPressed
                        ? questionList[index].options.values.toList()[i] == true
                        ? Colors.green
                        : Colors.red
                        : Colors.blue,
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: NextButtonWidget(
          nextQuestion: nextQuestion,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
