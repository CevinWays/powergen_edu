import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergen_edu/src/features/post_test/widgets/post_test_question_card.dart';

import '../home/home_page.dart';
import 'bloc/post_test_bloc/post_test_bloc.dart';

class PostTestPage extends StatelessWidget {
  final String? moduleId;

  const PostTestPage({super.key, this.moduleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => PostTestBloc()..onLoadQuestion(moduleId ?? ''),
        child: BlocConsumer<PostTestBloc, PostTestState>(
          listener: (context, state) {
            if (state is PostTestComplete) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                        child: Text(state.isSuccess ? 'Oke' : 'Ulangi lagi'),
                      ),
                    ],
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.isSuccess
                            ? 'Kamu sudah menyelesaikan post test. Silahkan lanjut ke Bab selanjutnya, point kamu adalah'
                            : 'Kamu sudah menyelesaikan post test. Maaf kamu harus mengulangi Bab $moduleId lagi, persyaratan ke bab selanjutnya adalah nilai >= 75 '
                                'point kamu adalah'),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            '${state.point}',
                            style: const TextStyle(
                                fontSize: 54, color: Colors.deepOrange),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Post Test'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<PostTestBloc>().onSubmitTest(moduleId ?? '');
                      debugPrint('Selesai');
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
                          child: SingleChildScrollView(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.questions.length,
                              shrinkWrap: true,
                              itemBuilder: (context, questionIndex) {
                                final questionNumber = questionIndex;
                                final question =
                                    state.questions[questionNumber];
                                return PostTestQuestionCard(
                                  question: question,
                                  onAnswerSelected: (answer) {
                                    context
                                        .read<PostTestBloc>()
                                        .onAnswerSelected(
                                          questionNumber: questionNumber,
                                          answer: answer,
                                        );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(child: Text('Error loading questions'));
                },
              ),
            );
          },
        ));
  }
}
