import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergen_edu/src/features/post_test/widgets/post_test_question_card.dart';

import '../home/home_page.dart';
import 'bloc/post_test_bloc/post_test_bloc.dart';

class PostTestPage extends StatelessWidget {
  const PostTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostTestBloc()..onLoadQuestion(),
      child: const PostTestView(),
    );
  }
}

class PostTestView extends StatelessWidget {
  const PostTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Test'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              debugPrint('Selesai');
              // context.read<Post TestBloc>().add(SubmitPostTest());
            },
            child: const Text('Selesai'),
          )
        ],
      ),
      body: BlocBuilder<PostTestBloc, PostTestState>(
        builder: (context, state) {
          if (state is PostTestLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PostTestLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.questions.length,
                    shrinkWrap: true,
                    itemBuilder: (context, questionIndex) {
                      final questionNumber = questionIndex;
                      final question = state.questions[questionNumber];
                      return PostTestQuestionCard(
                        question: question,
                        onAnswerSelected: (answer) {
                          context.read<PostTestBloc>().
                            onAnswerSelected(
                              questionNumber: questionNumber,
                              answer: answer,
                            );
                        },
                      );
                    },
                  ),
                ),
                // Expanded(
                //   child: PageView.builder(
                //     controller: state.pageController,
                //     itemCount: 4, // 5 questions per page
                //     onPageChanged: (index) {
                //       context.read<PostTestBloc>().add(PageChanged(index));
                //     },
                //     itemBuilder: (context, pageIndex) {
                //       return ListView.builder(
                //         itemCount: 5,
                //         itemBuilder: (context, questionIndex) {
                //           final questionNumber = pageIndex * 5 + questionIndex;
                //           final question = state.questions[questionNumber];
                //           return QuestionCard(
                //             question: question,
                //             onAnswerSelected: (answer) {
                //               context.read<PostTestBloc>().add(
                //                     AnswerSelected(
                //                       questionNumber: questionNumber,
                //                       answer: answer,
                //                     ),
                //                   );
                //             },
                //           );
                //         },
                //       );
                //     },
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     ElevatedButton(
                //       onPressed: () {
                //         // Handle previous navigation
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.grey[200],
                //         foregroundColor: Colors.black,
                //       ),
                //       child: const Text('Kembali'),
                //     ),
                //     ElevatedButton(
                //       onPressed: () {
                //         // Handle next navigation
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.deepOrange,
                //         foregroundColor: Colors.white,
                //       ),
                //       child: const Text('Selanjutnya'),
                //     ),
                //   ],
                // ),
              ],
            );
          }
          return const Center(child: Text('Error loading questions'));
        },
      ),
    );
  }
}
