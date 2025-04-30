class PretestQuestion {
  final int id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final int point;
  final int module;

  PretestQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.point,
    required this.module,
  });
}
