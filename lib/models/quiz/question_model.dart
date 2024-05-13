class MyQuizQuestion {
  int id;
  String question;
  Map<String, bool> options;

  MyQuizQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  @override
  String toString() {
    return "Question(id: $id, question: $question, options : $options)";
  }
}
