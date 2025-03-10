import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergen_edu/src/features/home/home_page.dart';
import 'package:powergen_edu/src/features/pretest/bloc/pretest_bloc.dart';
import 'package:powergen_edu/src/features/pretest/widgets/question_card.dart';

class PretestPage extends StatelessWidget {
  const PretestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PretestBloc()..add(LoadQuestions()),
      child: const PretestView(),
    );
  }
}

class PretestView extends StatelessWidget {
  const PretestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pretest'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              debugPrint('Selesai');
              // context.read<PretestBloc>().add(SubmitPretest());
            },
            child: const Text('Selesai'),
          )
        ],
      ),
      body: BlocBuilder<PretestBloc, PretestState>(
        builder: (context, state) {
          if (state is PretestLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PretestLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.questions.length,
                    shrinkWrap: true,
                    itemBuilder: (context, questionIndex) {
                      final questionNumber = questionIndex;
                      final question = state.questions[questionNumber];
                      return QuestionCard(
                        question: question,
                        onAnswerSelected: (answer) {
                          context.read<PretestBloc>().add(
                                AnswerSelected(
                                  questionNumber: questionNumber,
                                  answer: answer,
                                ),
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
                //       context.read<PretestBloc>().add(PageChanged(index));
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
                //               context.read<PretestBloc>().add(
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
