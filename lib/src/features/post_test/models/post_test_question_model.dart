class PostTestQuestionModel {
  final int id;
  final String question;
  final List<String> options;
  final String correctAnswer;

  PostTestQuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}
