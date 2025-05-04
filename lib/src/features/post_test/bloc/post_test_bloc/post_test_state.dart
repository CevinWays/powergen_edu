part of 'post_test_bloc.dart';

abstract class PostTestState {}

class InitPostTestState extends PostTestState {}

class PostTestLoading extends PostTestState {}

class PostTestLoaded extends PostTestState {
  final List<PostTestQuestionModel> questions;
  final int currentPage;
  final PageController pageController;
  final Map<int, String> answers;

  PostTestLoaded({
    required this.questions,
    required this.currentPage,
    required this.pageController,
    required this.answers,
  });

  PostTestLoaded copyWith({
    List<PostTestQuestionModel>? questions,
    int? currentPage,
    PageController? pageController,
    Map<int, String>? answers,
  }) {
    return PostTestLoaded(
      questions: questions ?? this.questions,
      currentPage: currentPage ?? this.currentPage,
      pageController: pageController ?? this.pageController,
      answers: answers ?? this.answers,
    );
  }
}

class PostTestComplete extends PostTestState {
  final bool isSuccess;
  final int point;

  PostTestComplete({
    required this.isSuccess,
    required this.point,
  });
}
