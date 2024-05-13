import 'package:flutter/material.dart';

class QuizResult extends StatelessWidget {
  const QuizResult({
    super.key,
    required this.score,
    required this.totalScore,
    required this.startOver,
  });

  final int score;
  final int totalScore;
  final VoidCallback startOver;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(70),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Score"),
            const SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 70,
              backgroundColor: score == totalScore
                  ? Colors.green
                  : score < totalScore / 2
                      ? Colors.red
                      : Colors.blue,
              child: Text(
                "$score/$totalScore",
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: startOver,
              child: const Text(
                "Start over",
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
