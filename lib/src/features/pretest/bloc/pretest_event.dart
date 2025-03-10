part of 'pretest_bloc.dart';

abstract class PretestEvent {}

class LoadQuestions extends PretestEvent {}

class PageChanged extends PretestEvent {
  final int page;
  PageChanged(this.page);
}

class AnswerSelected extends PretestEvent {
  final int questionNumber;
  final String answer;
  AnswerSelected({required this.questionNumber, required this.answer});
}

class SubmitTest extends PretestEvent {}
