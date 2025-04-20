import 'package:flutter/material.dart';
import 'package:powergen_edu/src/features/post_test/models/post_test_question_model.dart';
import 'package:powergen_edu/src/features/pretest/models/pretest_question.dart';

class PostTestQuestionCard extends StatefulWidget {
  final PostTestQuestionModel question;
  final Function(String) onAnswerSelected;

  const PostTestQuestionCard({
    super.key,
    required this.question,
    required this.onAnswerSelected,
  });

  @override
  State<PostTestQuestionCard> createState() => _PostTestQuestionCardState();
}

class _PostTestQuestionCardState extends State<PostTestQuestionCard> {
  String? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${widget.question.id}. ${widget.question.question}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...widget.question.options.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value;
                  });
                  if (value != null) {
                    widget.onAnswerSelected(value);
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
