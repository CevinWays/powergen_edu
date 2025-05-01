import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergen_edu/src/features/post_test/models/post_test_question_model.dart';

part 'post_test_state.dart';

class PostTestBloc extends Cubit<PostTestState> {
  PostTestBloc() : super(InitPostTestState());

  final PageController pageController = PageController();
  List<PostTestQuestionModel> questions = [];
  Map<int, String> answers = {};

  void onLoadQuestion() {
    final questions = <PostTestQuestionModel>[
      PostTestQuestionModel(
        id: 1,
        question:
            'Mengapa pemahaman prinsip konversi energi penting bagi operator sistem pembangkit listrik?',
        options: [
          'Agar dapat memperbaiki sistem pendingin',
          'Untuk mengetahui kapan mesin dimatikan',
          'Agar mampu mengidentifikasi jalur aliran energi dan mengoptimalkan efisiensi',
          'Supaya dapat menjalankan generator tanpa prosedur',
          'Karena sistem pembangkit bekerja otomatis'
        ],
        correctAnswer: '2',
      ),
      PostTestQuestionModel(
        id: 2,
        question:
            'Apa dampak utama jika transformator tidak sesuai spesifikasi dalam sistem pembangkit?',
        options: [
          'Menurunnya efisiensi pembakaran bahan bakar',
          'Ketidakseimbangan rotasi turbin',
          'Kehilangan daya selama transmisi dan distribusi',
          'Pengurangan kapasitas tangki bahan bakar',
          'Kelebihan produksi daya listrik'
        ],
        correctAnswer: '2',
      ),
      PostTestQuestionModel(
        id: 3,
        question:
            'Apa yang membedakan motor listrik dan generator dalam sistem pembangkit?',
        options: [
          'Motor menghasilkan listrik, generator menggerakkan beban',
          'Generator beroperasi dengan AC saja, motor hanya dengan DC',
          'Motor mengubah energi listrik menjadi gerak, generator sebaliknya',
          'Keduanya berfungsi sebagai sumber energi',
          'Motor dan generator memiliki sistem kontrol yang sama'
        ],
        correctAnswer: '2',
      ),
      PostTestQuestionModel(
        id: 4,
        question:
            'Dalam sistem pembangkit, kapan transformator step-down biasanya digunakan?',
        options: [
          'Sebelum tegangan masuk ke rumah tangga atau industri',
          'Saat tegangan sedang tinggi di pembangkit',
          'Untuk meningkatkan frekuensi arus listrik',
          'Saat daya reaktif meningkat',
          'Sebelum proses pembakaran bahan bakar'
        ],
        correctAnswer: '0',
      ),
      PostTestQuestionModel(
        id: 5,
        question:
            'Bagaimana penerapan hukum Faraday dapat diamati dalam proses kerja generator?',
        options: [
          'Ketika tegangan input meningkat akibat putaran turbin',
          'Saat konduktor diam di antara medan magnet',
          'Saat medan magnet berubah dan menimbulkan arus dalam konduktor',
          'Ketika transformator mengalami induksi resistif',
          'Ketika terjadi peningkatan suhu gulungan'
        ],
        correctAnswer: '2',
      ),
      PostTestQuestionModel(
        id: 6,
        question:
            'Apa keunggulan utama generator sinkron dibandingkan asinkron dalam pembangkitan skala besar?',
        options: [
          'Memerlukan ruang lebih kecil',
          'Lebih murah biaya perawatannya',
          'Lebih mudah untuk start tanpa beban',
          'Menyediakan stabilitas tegangan dan frekuensi lebih tinggi',
          'Tidak memerlukan kontrol manual'
        ],
        correctAnswer: '3',
      ),
      PostTestQuestionModel(
        id: 7,
        question:
            'Mengapa sistem pendingin diperlukan dalam mesin listrik pembangkit?',
        options: [
          'Agar dapat bekerja tanpa beban',
          'Untuk menurunkan tegangan input',
          'Mencegah overheating pada komponen penting seperti gulungan',
          'Menjaga kelembapan sistem kontrol',
          'Untuk meningkatkan putaran generator'
        ],
        correctAnswer: '2',
      ),
      PostTestQuestionModel(
        id: 8,
        question:
            'Jika sistem turbin mengalami hambatan mekanis, dampak yang paling mungkin terjadi adalah...',
        options: [
          'Peningkatan tegangan output',
          'Kestabilan arus meningkat',
          'Menurunnya efisiensi konversi energi dan potensi kerusakan generator',
          'Frekuensi tetap stabil',
          'Peningkatan tekanan bahan bakar'
        ],
        correctAnswer: '2',
      ),
      PostTestQuestionModel(
        id: 9,
        question:
            'Mengapa penting bagi peserta didik memahami alur konversi energi pada sistem pembangkit?',
        options: [
          'Agar dapat mendesain sistem kelistrikan rumah tangga',
          'Supaya tahu kapan turbin dinyalakan manual',
          'Untuk memahami interkoneksi antara peralatan pembangkit',
          'Supaya dapat menghitung tegangan output secara eksak',
          'Agar bisa mengganti sistem SCADA'
        ],
        correctAnswer: '2',
      ),
      PostTestQuestionModel(
        id: 10,
        question:
            'Apa akibat jika sistem monitoring tegangan dan beban tidak digunakan dalam pembangkit?',
        options: [
          'Tidak ada pengaruh signifikan',
          'Terjadi efisiensi maksimal namun tidak terkontrol',
          'Sulit mendeteksi gangguan beban dan lonjakan arus',
          'Tegangan menjadi terlalu stabil',
          'Frekuensi menjadi otomatis'
        ],
        correctAnswer: '2',
      ),
      PostTestQuestionModel(
        id: 11,
        question:
            'Apa hubungan antara transformator dan efisiensi transmisi daya listrik jarak jauh?',
        options: [
          'Transformator menurunkan arus agar daya bertambah',
          'Transformator meningkatkan tegangan untuk mengurangi rugi daya',
          'Transformator mengalihkan daya ke sistem backup',
          'Transformator menstabilkan frekuensi turbin',
          'Transformator menyimpan energi saat beban rendah'
        ],
        correctAnswer: '1',
      ),
      PostTestQuestionModel(
        id: 12,
        question:
            'Mengapa penting mengetahui karakteristik motor listrik dalam sistem pembangkit?',
        options: [
          'Agar dapat mengganti transformator',
          'Supaya tahu kapasitas tangki oli',
          'Untuk memastikan efisiensi kerja alat bantu seperti pompa',
          'Karena motor tidak memerlukan pengontrol',
          'Agar bisa memperbesar ukuran turbin'
        ],
        correctAnswer: '2',
      ),
      PostTestQuestionModel(
        id: 13,
        question:
            'Bagaimana generator menghasilkan arus listrik dalam sistem pembangkit?',
        options: [
          'Dengan mengubah energi listrik menjadi energi panas',
          'Dengan rotasi magnet di sekitar kumparan sehingga terjadi induksi',
          'Melalui kompresi udara dalam ruang isolasi',
          'Dengan memanaskan kumparan secara konstan',
          'Menggunakan bahan kimia untuk menghasilkan listrik'
        ],
        correctAnswer: '1',
      ),
      PostTestQuestionModel(
        id: 14,
        question:
            'Kapan turbin air paling efisien digunakan dalam sistem pembangkit?',
        options: [
          'Saat tekanan air rendah',
          'Saat digunakan pada wilayah datar tanpa bendungan',
          'Ketika memiliki sumber air bertekanan tinggi dan debit besar',
          'Pada malam hari dengan beban ringan',
          'Saat cuaca panas untuk meningkatkan uap'
        ],
        correctAnswer: '2',
      ),
      PostTestQuestionModel(
        id: 15,
        question:
            'Apa akibat jika tegangan dari generator langsung disalurkan ke rumah tanpa transformator?',
        options: [
          'Sistem rumah menjadi lebih efisien',
          'Tidak terjadi perubahan karena generator sudah aman',
          'Dapat merusak peralatan rumah tangga akibat tegangan tinggi',
          'Frekuensi listrik tidak terdeteksi',
          'Menghasilkan daya lebih besar'
        ],
        correctAnswer: '2',
      ),
      PostTestQuestionModel(
        id: 16,
        question:
            'Apa fungsi utama AVR (Automatic Voltage Regulator) dalam sistem pembangkit?',
        options: [
          'Mengatur laju bahan bakar',
          'Mengendalikan suhu pendingin',
          'Menstabilkan tegangan output dari generator',
          'Mengganti posisi rotor generator',
          'Menyimpan energi listrik cadangan'
        ],
        correctAnswer: '2',
      ),
      PostTestQuestionModel(
        id: 17,
        question:
            'Apa peran utama sistem bahan bakar dalam pembangkit listrik termal?',
        options: [
          'Menurunkan suhu pada ruang kontrol',
          'Memberikan tekanan pada sistem SCADA',
          'Menyediakan energi awal untuk memutar turbin',
          'Mengganti air dalam sistem pendingin',
          'Menjaga efisiensi transformator'
        ],
        correctAnswer: '2',
      ),
      PostTestQuestionModel(
        id: 18,
        question: 'Mengapa penting melakukan pemantauan terhadap sistem transformator?',
        options: [
          'Karena transformator tidak memerlukan pemeliharaan',
          'Supaya bisa dinyalakan manual saat malam hari',
          'Untuk mendeteksi gangguan seperti arus tidak seimbang atau kebocoran oli',
          'Karena transformator hanya bekerja saat beban tinggi',
          'Untuk menyalakan turbin secara otomatis'
        ],
        correctAnswer: '2',
      ),
      PostTestQuestionModel(
        id: 19,
        question: 'Bagaimana sistem pendingin berfungsi dalam menjaga stabilitas generator?',
        options: [
          'Dengan menurunkan frekuensi output',
          'Dengan menjaga suhu kerja agar tidak melebihi ambang batas',
          'Dengan mengalirkan uap panas ke sistem kontrol',
          'Dengan menambah bahan bakar saat suhu tinggi',
          'Dengan menghentikan aliran listrik secara periodik'
        ],
        correctAnswer: '1',
      ),
      PostTestQuestionModel(
        id: 20,
        question: 'Apa perbedaan utama antara turbin uap dan turbin gas dalam sistem pembangkit?',
        options: [
          'Turbin uap menggunakan bahan bakar cair, turbin gas tidak',
          'Turbin uap memerlukan sistem kondensasi setelah ekspansi',
          'Turbin gas menghasilkan arus langsung, turbin uap tidak',
          'Turbin uap tidak memerlukan pendinginan',
          'Turbin gas menggunakan air sebagai media tekanan'
        ],
        correctAnswer:
            '1',
      ),
    ];
    emit(PostTestLoaded(
      questions: questions,
      currentPage: 0,
      pageController: pageController,
      answers: answers,
    ));
  }

  void onPageChanged(int page) {
    if (state is PostTestLoaded) {
      emit((state as PostTestLoaded).copyWith(currentPage: page));
    }
  }

  void onAnswerSelected({
    required int questionNumber,
    required String answer,
  }) {
    answers[questionNumber] = answer;
    if (state is PostTestLoaded) {
      emit((state as PostTestLoaded).copyWith(answers: answers));
    }
  }

  void onSubmitTest() {
    if (state is PostTestLoaded) {
      int correctAnswers = 0;
      answers.forEach((index, answer) {
        if (answer == questions[index].correctAnswer) {
          correctAnswers++;
        }
      });

      final score = (correctAnswers / questions.length) * 100;

      if (score == 100) {
        emit(PostTestComplete(moduleToUnlock: 4)); // Skip to module 4
      } else if (score >= 85) {
        emit(PostTestComplete(moduleToUnlock: 3));
      } else if (score >= 50) {
        emit(PostTestComplete(moduleToUnlock: 2));
      } else {
        emit(PostTestComplete(moduleToUnlock: 1));
      }
    }
  }
}
