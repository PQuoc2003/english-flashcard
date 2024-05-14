class TypingQuestion {
  int id;
  String prompt;
  String answer;
  String userAnswer;

  TypingQuestion({
    required this.id,
    required this.prompt,
    required this.answer,
    this.userAnswer = '',
  });

  bool checkAnswer() {
    return userAnswer.trim().toLowerCase() == answer.trim().toLowerCase();
  }

  @override
  String toString() {
    return "TypingQuestion(id: $id, prompt: $prompt, answer: $answer, userAnswer: $userAnswer)";
  }
}
