part of 'pretest_bloc.dart';

abstract class PretestState {}

class PretestLoading extends PretestState {}

class PretestLoaded extends PretestState {
  final List<PretestQuestion> questions;
  final int currentPage;
  final PageController pageController;
  final Map<int, String> answers;

  PretestLoaded({
    required this.questions,
    required this.currentPage,
    required this.pageController,
    required this.answers,
  });

  PretestLoaded copyWith({
    List<PretestQuestion>? questions,
    int? currentPage,
    PageController? pageController,
    Map<int, String>? answers,
  }) {
    return PretestLoaded(
      questions: questions ?? this.questions,
      currentPage: currentPage ?? this.currentPage,
      pageController: pageController ?? this.pageController,
      answers: answers ?? this.answers,
    );
  }
}

class PretestComplete extends PretestState {}
