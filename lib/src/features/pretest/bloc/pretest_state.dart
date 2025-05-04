part of 'pretest_bloc.dart';

abstract class PretestState {}

class PretestLoading extends PretestState {}

class PretestLoaded extends PretestState {
  final List<PretestQuestion>? questions;
  final int? currentPage;
  final PageController? pageController;
  final Map<int, String>? answers;
  final String? errorMessage;

  PretestLoaded({
    this.questions,
    this.currentPage,
    this.pageController,
    this.answers,
    this.errorMessage,
  });

  PretestLoaded copyWith({
    List<PretestQuestion>? questions,
    int? currentPage,
    PageController? pageController,
    Map<int, String>? answers,
    String? errorMessage,
  }) {
    return PretestLoaded(
      questions: questions ?? this.questions,
      currentPage: currentPage ?? this.currentPage,
      pageController: pageController ?? this.pageController,
      answers: answers ?? this.answers,
      errorMessage: errorMessage,
    );
  }
}

class PretestComplete extends PretestState {}
