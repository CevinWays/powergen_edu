import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergen_edu/src/features/pretest/models/pretest_question.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'pretest_event.dart';

part 'pretest_state.dart';

class PretestBloc extends Bloc<PretestEvent, PretestState> {
  final PageController pageController = PageController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
        question:
            'Mengapa generator sinkron lebih banyak digunakan pada pembangkit listrik skala besar dibandingkan generator asinkron?',
        options: [
          'Karena lebih murah biaya produksinya',
          'Karena tidak memerlukan sistem pendingin',
          'Karena dapat beroperasi tanpa sinkronisasi',
          'Karena mampu menjaga stabilitas frekuensi dan tegangan',
          'Karena lebih ringan bobotnya'
        ],
        correctAnswer: '3',
        point: 6,
        module: 1,
      ),
      PretestQuestion(
        id: 2,
        question:
            'Apa alasan utama penggunaan transformator step-up pada awal sistem transmisi tenaga listrik?',
        options: [
          'Untuk menurunkan rugi daya akibat arus tinggi',
          'Agar tegangan tetap konstan di gardu induk',
          'Karena generator menghasilkan tegangan sangat tinggi',
          'Untuk menghemat biaya instalasi kabel',
          'Untuk mengurangi kecepatan arus listri'
        ],
        correctAnswer: '0',
        point: 6,
        module: 1,
      ),
      PretestQuestion(
        id: 3,
        question:
            'Bagaimana hubungan prinsip kerja generator dengan hukum Faraday tentang induksi elektromagnetik?',
        options: [
          'Medan magnet memutus arus dalam rangkaian tertutup',
          'Arus listrik menggerakkan medan magnet untuk menghasilkan gerak',
          'Perubahan medan magnet dalam konduktor menghasilkan arus listrik',
          'Konduktor selalu menghasilkan medan magnet saat diberi arus tetap',
          'Medan magnet menyebabkan hambatan listrik meningkat'
        ],
        correctAnswer: '2',
        point: 6,
        module: 1,
      ),
      PretestQuestion(
        id: 4,
        question:
            'Jika terjadi ketidakseimbangan beban pada sistem pembangkit, dampak yang paling mungkin terjadi adalah...',
        options: [
          'Penurunan daya reaktif secara drastis',
          'Overheating pada sistem kontrol',
          'Distorsi bentuk gelombang arus dan tegangan',
          'Percepatan putaran turbin',
          'Meningkatnya efisiensi sistem'
        ],
        correctAnswer: '2',
        point: 6,
        module: 1,
      ),
      PretestQuestion(
        id: 5,
        question:
            'Salah satu indikator efisiensi operasional pembangkit adalah kemampuan...',
        options: [
          'Menghasilkan tegangan konstan tanpa fluktuasi beban',
          'Menurunkan arus dan menaikkan suhu sistem',
          'Menyimpan energi lebih lama saat shutdown',
          'Mengabaikan faktor cos φ (faktor daya)',
          'Menstabilkan suhu ruangan di ruang kontrol'
        ],
        correctAnswer: '0',
        point: 6,
        module: 1,
      ),
      PretestQuestion(
        id: 6,
        question:
            'Mengapa pemeliharaan preventif lebih disarankan dibandingkan menunggu kerusakan terjadi?',
        options: [
          'Karena mengurangi kebutuhan akan dokumentasi',
          'Karena mempercepat proses shutdown sistem',
          'Karena dapat menurunkan biaya operasional jangka panjang',
          'Karena tidak memerlukan teknisi ahli',
          'Karena hanya dilakukan saat mesin dalam keadaan mati total'
        ],
        correctAnswer: '2',
        point: 6,
        module: 2,
      ),
      PretestQuestion(
        id: 7,
        question:
            'Bagaimana cara kerja sinkronoskop dalam proses sinkronisasi generator?',
        options: [
          'Mengukur suhu dan tekanan dalam stator',
          'Membandingkan tegangan output dengan input jaringan',
          'Mendeteksi perbedaan frekuensi dan sudut fase antara generator dan jaringan',
          'Menstabilkan arus dan tegangan secara otomatis',
          'Mendeteksi arus bocor pada sistem grounding'
        ],
        correctAnswer: '2',
        point: 6,
        module: 2,
      ),
      PretestQuestion(
        id: 8,
        question:
            'Ketika sistem pendingin generator gagal berfungsi, dampak paling kritis yang harus dihindari adalah...',
        options: [
          'Hilangnya data pemantauan beban',
          'Meledaknya transformator akibat arus lebih',
          'Kegagalan sinkronisasi generator',
          'Terjadinya overheating pada gulungan stator',
          'Gangguan komunikasi antara panel kontrol dan HMI'
        ],
        correctAnswer: '3',
        point: 6,
        module: 2,
      ),
      PretestQuestion(
        id: 9,
        question:
            'Apa peran sistem SCADA dalam pengoperasian sistem pembangkit modern?',
        options: [
          'Menyimpan daya cadangan untuk beban puncak',
          'Menyinkronkan semua generator secara otomatis',
          'Mengontrol dan memantau sistem pembangkit secara terpusat dan real-time',
          'Menjaga tekanan bahan bakar agar tetap rendah',
          'Mengatur rotasi turbin agar konstan'
        ],
        correctAnswer: '2',
        point: 6,
        module: 2,
      ),
      PretestQuestion(
        id: 10,
        question:
            'Apa yang seharusnya dilakukan teknisi saat alarm suhu tinggi aktif pada sistem generator?',
        options: [
          'Melanjutkan operasi hingga batas maksimal dicapai',
          'Segera melakukan shutdown darurat dan pendinginan',
          'Menurunkan beban dan menunggu suhu turun otomatis',
          'Mengatur ulang setelan sensor suhu',
          'Menghidupkan kembali sistem pendingin cadangan tanpa inspeksi'
        ],
        correctAnswer: '1',
        point: 6,
        module: 2,
      ),
      PretestQuestion(
        id: 11,
        question:
            'Mengapa dokumentasi pemeliharaan sangat penting dalam sistem pembangkit?',
        options: [
          'Sebagai bukti hukum jika terjadi kerusakan',
          'Untuk keperluan pelaporan ke dinas lingkungan',
          'Untuk mengevaluasi efektivitas pemeliharaan dan menganalisis pola gangguan',
          'Untuk menyimpan riwayat karyawan yang melakukan tugas',
          'Agar teknisi dapat mengganti jadwal operasional'
        ],
        correctAnswer: '2',
        point: 4,
        module: 3,
      ),
      PretestQuestion(
        id: 12,
        question:
            'Apa penyebab umum terjadinya ketidakseimbangan arus pada transformator?',
        options: [
          'Gangguan sistem grounding',
          'Kelebihan beban pada salah satu fasa',
          'Efek kapasitansi reaktif',
          'Frekuensi terlalu tinggi',
          'Tegangan output tidak disetel'
        ],
        correctAnswer: '1',
        point: 4,
        module: 3,
      ),
      PretestQuestion(
        id: 13,
        question:
            'Jika salah satu parameter monitoring menunjukkan lonjakan abnormal, apa langkah pertama yang harus dilakukan?',
        options: [
          'Meningkatkan beban secara bertahap',
          'Menghentikan sistem SCADA',
          'Menganalisis penyebab lonjakan dan lakukan pengamatan lebih lanjut',
          'Melakukan bypass sistem untuk menghindari alarm',
          'Menonaktifkan semua sensor untuk menghindari false alarm'
        ],
        correctAnswer: '2',
        point: 4,
        module: 3,
      ),
      PretestQuestion(
        id: 14,
        question:
            'Bagaimana prinsip kerja sistem pelumasan otomatis pada generator?',
        options: [
          'Mengaktifkan pompa manual setiap 2 jam',
          'Mengukur getaran dan tekanan, lalu menyesuaikan aliran pelumas',
          'Menyemprotkan pelumas hanya saat shutdown',
          'Menyalakan sistem pelumas saat suhu menurun',
          'Mengisi ulang pelumas setiap 500 jam kerja'
        ],
        correctAnswer: '1',
        point: 4,
        module: 3,
      ),
      PretestQuestion(
        id: 15,
        question:
            'Kapan waktu terbaik melakukan pemeliharaan tahunan sistem pembangkit?',
        options: [
          'Saat musim hujan',
          'Saat beban puncak tinggi',
          'Saat sistem bekerja dalam kapasitas penuh',
          'Saat beban sistem sedang rendah',
          'Saat gangguan jaringan terjadi'
        ],
        correctAnswer: '3',
        point: 4,
        module: 3,
      ),
      PretestQuestion(
        id: 16,
        question:
            'Apa tujuan penggunaan vibration sensor dalam predictive maintenance?',
        options: [
          'Mendeteksi tegangan arus tidak seimbang',
          'Mengukur suhu lingkungan',
          'Mendeteksi getaran abnormal yang menandakan kerusakan mekanis awal',
          'Mengatur kecepatan turbin',
          'Mengontrol kelembaban di ruang generator'
        ],
        correctAnswer: '2',
        point: 4,
        module: 3,
      ),
      PretestQuestion(
        id: 17,
        question:
            'Dalam situasi darurat saat sistem bahan bakar bocor, langkah pertama yang dilakukan adalah...',
        options: [
          'Menyalakan kipas tambahan untuk mengurangi tekanan',
          'Melaporkan ke divisi pemeliharaan untuk ditindaklanjuti',
          'Melakukan prosedur pemadaman dan mengisolasi area bocor',
          'Melanjutkan operasi hingga bahan bakar habis',
          'Mencatat kejadian dan menunggu audit'
        ],
        correctAnswer: '2',
        point: 4,
        module: 3,
      ),
      PretestQuestion(
        id: 18,
        question:
            'Mengapa sistem kontrol digital lebih efektif dalam monitoring sistem pembangkit?',
        options: [
          'Karena tidak membutuhkan operator manusia',
          'Karena lebih cepat dan akurat dalam pengolahan data real-time',
          'Karena dapat menggantikan semua fungsi transformator',
          'Karena hanya bekerja saat malam hari',
          'Karena tidak membutuhkan sensor sama sekali'
        ],
        correctAnswer: '1',
        point: 4,
        module: 3,
      ),
      PretestQuestion(
        id: 19,
        question:
            'Apa manfaat melakukan analisis termal dengan thermal camera pada peralatan pembangkit?',
        options: [
          'Menentukan kelembaban udara',
          'Mengidentifikasi titik panas yang berpotensi kerusakan',
          'Menurunkan suhu ambient ruangan',
          'Meningkatkan kecepatan sistem pendingin',
          'Mengukur level oli pelumas'
        ],
        correctAnswer: '1',
        point: 4,
        module: 3,
      ),
      PretestQuestion(
        id: 20,
        question:
            'Jika terdapat kebocoran pelumas pada motor penggerak, maka yang paling mungkin terjadi adalah...',
        options: [
          'Peningkatan efisiensi sistem',
          'Penurunan suhu operasional',
          'Kerusakan pada bantalan dan peningkatan gesekan',
          'Penurunan tekanan udara dalam sistem',
          'Gangguan pada sistem alarm'
        ],
        correctAnswer: '2',
        point: 4,
        module: 3,
      ),
    ];
    this.questions = questions;
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

  FutureOr<void> _onSubmitTest(
      SubmitTest event, Emitter<PretestState> emit) async {
    if (state is PretestLoaded) {
      int totalPoint = 0;
      int totalScoreBab1 = 0;
      int totalScoreBab2 = 0;
      int totalScoreBab3 = 0;

      answers.forEach((index, answer) {
        if (answer == questions[index].correctAnswer) {
          if (questions[index].module == 1) {
            // totalScoreBab1 += questions[index].point;
          } else if (questions[index].module == 2) {
            // totalScoreBab2 += questions[index].point;
          } else if (questions[index].module == 3) {
            // totalScoreBab3 += questions[index].point;
          }

          totalPoint += questions[index].point;
        }
      });

      totalScoreBab1 = 18;
      totalScoreBab2 = 24;
      totalScoreBab3 = 20;
      //TODO send point to firestore (table user -> point_pretest, is_done_pretest, and total_progress)
      // and create all 4 module data in table module
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid') ?? '';
      final userRef = _firestore.collection('users').doc(uid);

      _firestore.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userRef);

        if (userSnapshot.exists) {
          transaction.update(userRef, {
            'point_pretest': totalPoint,
            'is_done_pretest': true,
            'total_progress': totalPoint,
          });
        }
      });

      final moduleRef = _firestore.collection('modules');

      moduleRef.doc('$uid-module-1').set({
        'uid': uid,
        'id_module': 1,
        'is_locked': totalScoreBab1 > 22
            ? false
            : totalScoreBab2 >= 22
                ? false
                : true,
        'point': totalScoreBab1,
      });

      moduleRef.doc('$uid-module-2').set({
        'uid': uid,
        'id_module': 2,
        'is_locked': totalScoreBab2 > 22
            ? false
            : true,
        'point': totalScoreBab2,
      });

      moduleRef.doc('$uid-module-3').set({
        'uid': uid,
        'id_module': 3,
        'is_locked': true,
        'point': totalScoreBab3,
      });

      moduleRef.doc('$uid-module-4').set({
        'uid': uid,
        'id_module': 4,
        'is_locked': true,
        'point': 0,
      });

      emit(PretestComplete());
    }
  }
}
