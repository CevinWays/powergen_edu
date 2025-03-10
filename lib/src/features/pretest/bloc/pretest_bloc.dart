import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergen_edu/src/features/pretest/models/pretest_question.dart';

part 'pretest_event.dart';
part 'pretest_state.dart';

class PretestBloc extends Bloc<PretestEvent, PretestState> {
  final PageController pageController = PageController();
  List<PretestQuestion> questions = [];
  Map<int, String> answers = {};

  PretestBloc() : super(PretestLoading()) {
    on<LoadQuestions>(_onLoadQuestions);
    on<PageChanged>(_onPageChanged);
    on<AnswerSelected>(_onAnswerSelected);
    on<SubmitTest>(_onSubmitTest);
  }

  void _onLoadQuestions(LoadQuestions event, Emitter<PretestState> emit) {
    final questions = <PretestQuestion>[
      PretestQuestion(
        id: 1,
        question: 'Apa yang dimaksud dengan torsi?',
        options: [
          'Gaya yang menyebabkan benda berputar',
          'Kecepatan putaran mesin',
          'Tekanan dalam silinder',
          'Daya mesin'
        ],
        correctAnswer: 'Gaya yang menyebabkan benda berputar',
      ),
      PretestQuestion(
        id: 2,
        question:
            'Komponen apa yang berfungsi untuk mengubah gerak translasi menjadi gerak rotasi pada mesin?',
        options: ['Piston', 'Crankshaft', 'Camshaft', 'Connecting rod'],
        correctAnswer: 'Crankshaft',
      ),
      PretestQuestion(
        id: 3,
        question: 'Apa fungsi utama dari radiator pada mesin?',
        options: [
          'Menghasilkan listrik',
          'Mendinginkan mesin',
          'Menyaring udara',
          'Mengatur bahan bakar'
        ],
        correctAnswer: 'Mendinginkan mesin',
      ),
      PretestQuestion(
        id: 4,
        question:
            'Satuan tekanan yang umum digunakan dalam sistem mesin adalah?',
        options: ['Pascal (Pa)', 'Watt (W)', 'Volt (V)', 'Ampere (A)'],
        correctAnswer: 'Pascal (Pa)',
      ),
      PretestQuestion(
        id: 5,
        question: 'Apa fungsi dari karburator pada mesin konvensional?',
        options: [
          'Mencampur udara dan bahan bakar',
          'Menyaring oli',
          'Mengatur timing pengapian',
          'Mendinginkan mesin'
        ],
        correctAnswer: 'Mencampur udara dan bahan bakar',
      ),
      PretestQuestion(
        id: 6,
        question:
            'Komponen apa yang berfungsi untuk menyekat ruang bakar pada mesin?',
        options: ['Piston ring', 'Valve spring', 'Timing belt', 'Oil filter'],
        correctAnswer: 'Piston ring',
      ),
      PretestQuestion(
        id: 7,
        question: 'Apa yang dimaksud dengan RPM?',
        options: [
          'Rotasi Per Menit',
          'Rasio Perbandingan Mesin',
          'Rate Power Machine',
          'Relative Position Measurement'
        ],
        correctAnswer: 'Rotasi Per Menit',
      ),
      PretestQuestion(
        id: 8,
        question:
            'Sistem pengapian pada mesin bensin modern umumnya menggunakan?',
        options: [
          'Sistem karburator',
          'Sistem injeksi elektronik',
          'Sistem manual',
          'Sistem hybrid'
        ],
        correctAnswer: 'Sistem injeksi elektronik',
      ),
      PretestQuestion(
        id: 9,
        question: 'Apa fungsi dari timing belt/timing chain?',
        options: [
          'Mensinkronkan putaran crankshaft dan camshaft',
          'Mengatur kecepatan mesin',
          'Mengatur suhu mesin',
          'Mengatur tekanan oli'
        ],
        correctAnswer: 'Mensinkronkan putaran crankshaft dan camshaft',
      ),
      PretestQuestion(
        id: 10,
        question:
            'Komponen apa yang mengatur masuk dan keluarnya gas pada ruang bakar?',
        options: ['Katup (valve)', 'Piston', 'Connecting rod', 'Spark plug'],
        correctAnswer: 'Katup (valve)',
      ),
      PretestQuestion(
        id: 11,
        question: 'Apa fungsi dari sistem pelumasan pada mesin?',
        options: [
          'Mengurangi gesekan antar komponen',
          'Meningkatkan tenaga mesin',
          'Mengatur suhu mesin',
          'Mengatur bahan bakar'
        ],
        correctAnswer: 'Mengurangi gesekan antar komponen',
      ),
      PretestQuestion(
        id: 12,
        question: 'Apa yang dimaksud dengan kompresi pada mesin?',
        options: [
          'Pemampatan campuran udara-bahan bakar',
          'Pembakaran bahan bakar',
          'Pembuangan gas sisa',
          'Pemasukan udara bersih'
        ],
        correctAnswer: 'Pemampatan campuran udara-bahan bakar',
      ),
      PretestQuestion(
        id: 13,
        question: 'Berapakah siklus langkah pada mesin 4 tak?',
        options: [
          'Hisap-Kompresi-Usaha-Buang',
          'Hisap-Kompresi-Buang',
          'Kompresi-Usaha-Buang',
          'Hisap-Usaha-Buang'
        ],
        correctAnswer: 'Hisap-Kompresi-Usaha-Buang',
      ),
      PretestQuestion(
        id: 14,
        question: 'Apa fungsi dari flywheel (roda gila)?',
        options: [
          'Menyimpan momentum putar',
          'Mengatur kecepatan mesin',
          'Mendinginkan mesin',
          'Mengatur bahan bakar'
        ],
        correctAnswer: 'Menyimpan momentum putar',
      ),
      PretestQuestion(
        id: 15,
        question:
            'Komponen apa yang mengubah energi listrik menjadi percikan api pada mesin bensin?',
        options: ['Busi (spark plug)', 'Alternator', 'Starter', 'Battery'],
        correctAnswer: 'Busi (spark plug)',
      ),
      PretestQuestion(
        id: 16,
        question: 'Apa yang dimaksud dengan displacement mesin?',
        options: [
          'Volume total silinder mesin',
          'Kecepatan maksimum mesin',
          'Tekanan kompresi mesin',
          'Konsumsi bahan bakar'
        ],
        correctAnswer: 'Volume total silinder mesin',
      ),
      PretestQuestion(
        id: 17,
        question:
            'Sistem pendinginan pada mesin umumnya menggunakan media apa?',
        options: ['Air dan coolant', 'Oli', 'Udara', 'Bahan bakar'],
        correctAnswer: 'Air dan coolant',
      ),
      PretestQuestion(
        id: 18,
        question: 'Apa fungsi dari gasket pada mesin?',
        options: [
          'Mencegah kebocoran',
          'Mengatur timing',
          'Menyaring oli',
          'Mengatur bahan bakar'
        ],
        correctAnswer: 'Mencegah kebocoran',
      ),
      PretestQuestion(
        id: 19,
        question: 'Apa yang dimaksud dengan firing order?',
        options: [
          'Urutan pembakaran silinder',
          'Urutan pemasangan busi',
          'Urutan pergantian oli',
          'Urutan starter mesin'
        ],
        correctAnswer: 'Urutan pembakaran silinder',
      ),
      PretestQuestion(
        id: 20,
        question: 'Apa fungsi dari turbocharger pada mesin?',
        options: [
          'Meningkatkan tenaga mesin dengan memampatkan udara masuk',
          'Mengurangi konsumsi bahan bakar',
          'Mendinginkan mesin',
          'Mengurangi emisi gas buang'
        ],
        correctAnswer:
            'Meningkatkan tenaga mesin dengan memampatkan udara masuk',
      ),
    ];
    emit(PretestLoaded(
      questions: questions,
      currentPage: 0,
      pageController: pageController,
      answers: answers,
    ));
  }

  void _onPageChanged(PageChanged event, Emitter<PretestState> emit) {
    if (state is PretestLoaded) {
      emit((state as PretestLoaded).copyWith(currentPage: event.page));
    }
  }

  void _onAnswerSelected(AnswerSelected event, Emitter<PretestState> emit) {
    answers[event.questionNumber] = event.answer;
    if (state is PretestLoaded) {
      emit((state as PretestLoaded).copyWith(answers: answers));
    }
  }

  void _onSubmitTest(SubmitTest event, Emitter<PretestState> emit) {
    if (state is PretestLoaded) {
      int correctAnswers = 0;
      answers.forEach((index, answer) {
        if (answer == questions[index].correctAnswer) {
          correctAnswers++;
        }
      });

      final score = (correctAnswers / questions.length) * 100;

      if (score == 100) {
        emit(PretestComplete(moduleToUnlock: 4)); // Skip to module 4
      } else if (score >= 85) {
        emit(PretestComplete(moduleToUnlock: 3));
      } else if (score >= 50) {
        emit(PretestComplete(moduleToUnlock: 2));
      } else {
        emit(PretestComplete(moduleToUnlock: 1));
      }
    }
  }
}
