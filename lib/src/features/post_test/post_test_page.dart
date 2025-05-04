import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:powergen_edu/src/features/modules/module_detail_page.dart';
import 'package:powergen_edu/src/features/post_test/widgets/post_test_question_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_page.dart';
import 'bloc/post_test_bloc/post_test_bloc.dart';

class PostTestPage extends StatelessWidget {
  final String? moduleId;

  const PostTestPage({super.key, this.moduleId});

  Future<void> _uploadPDF(BuildContext context) async {
    try {
      // Check and request storage permission
      final permissionStatus = await Permission.storage.request();

      if (!permissionStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Izin untuk mengakses penyimpanan diperlukan',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      const limitSize = 5 * 1024 * 1024; // 5 MB

      if (result != null && result.files.first.size > limitSize) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File PDF tidak boleh lebih dari 5 mb',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (result != null) {
        final file = result.files.first;
        final fileName = file.name;
        final uid = prefs.getString('uid') ?? '';
        final name = prefs.getString('fullName') ?? '';

        // Create reference to Firebase Storage
        final storageRef =
            FirebaseStorage.instance.ref().child('student_pdfs/$uid/$fileName');

        // Upload file
        if (file.path != null) {
          await storageRef.putFile(File(file.path!));
        } else {
          throw Exception('File path is null');
        }

        // Get download URL
        final downloadUrl = await storageRef.getDownloadURL();

        // Save reference to Firestore
        if (context.mounted) {
          await FirebaseFirestore.instance.collection('student_pdfs').add({
            'userId': uid,
            'fileName': fileName,
            'downloadUrl': downloadUrl,
            'uploadedAt': DateTime.now(),
            'studentName': name,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Praktikum berhasil diunggah',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}',
              style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                            ? 'Kamu sudah menyelesaikan post test. Maaf kamu harus mengulangi Bab $moduleId lagi, point kamu adalah'
                            : 'Kamu sudah menyelesaikan post test. Silahkan lanjut ke Bab selanjutnya, point kamu adalah'),
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
                  if (moduleId == '4') ...[
                    IconButton(
                      icon: const Icon(Icons.upload_file),
                      onPressed: () => _uploadPDF(context),
                      tooltip: 'Upload Praktikum',
                    ),
                  ],
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
                          child: ListView.builder(
                            itemCount: state.questions.length,
                            shrinkWrap: true,
                            itemBuilder: (context, questionIndex) {
                              final questionNumber = questionIndex;
                              final question = state.questions[questionNumber];
                              return PostTestQuestionCard(
                                question: question,
                                onAnswerSelected: (answer) {
                                  context.read<PostTestBloc>().onAnswerSelected(
                                        questionNumber: questionNumber,
                                        answer: answer,
                                      );
                                },
                              );
                            },
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
