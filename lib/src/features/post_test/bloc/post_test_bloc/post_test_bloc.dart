import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergen_edu/src/features/post_test/models/post_test_question_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'post_test_state.dart';

class PostTestBloc extends Cubit<PostTestState> {
  PostTestBloc() : super(InitPostTestState());

  final PageController pageController = PageController();
  List<PostTestQuestionModel> questions = [];
  Map<int, String> answers = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> savePdfReference({
    required String userId,
    required String fileName,
    required String downloadUrl,
    required String studentName,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('student_pdfs').add({
        'userId': userId,
        'fileName': fileName,
        'downloadUrl': downloadUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
        'studentName': studentName,
      });
    } catch (e) {
      throw Exception('Failed to save PDF reference: $e');
    }
  }

  void onLoadQuestion(String moduleId) {
    emit(PostTestLoading());

    List<PostTestQuestionModel> questions = [];
    if (moduleId == '1') {
      questions = <PostTestQuestionModel>[
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
          question:
              'Mengapa penting melakukan pemantauan terhadap sistem transformator?',
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
          question:
              'Bagaimana sistem pendingin berfungsi dalam menjaga stabilitas generator?',
          options: [
            'Dengan menurunkan frekuensi output',
            'Dengan menjaga suhu kerja agar tidak melebihi ambang batas',
            'Dengan mengalirkan uap panas ke sistem kontrol',
            'Dengan menambah bahan bakar saat suhu tinggi',
            'Dengan menghentikan aliran listrik secara periodik'
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 20,
          question:
              'Apa perbedaan utama antara turbin uap dan turbin gas dalam sistem pembangkit?',
          options: [
            'Turbin uap menggunakan bahan bakar cair, turbin gas tidak',
            'Turbin uap memerlukan sistem kondensasi setelah ekspansi',
            'Turbin gas menghasilkan arus langsung, turbin uap tidak',
            'Turbin uap tidak memerlukan pendinginan',
            'Turbin gas menggunakan air sebagai media tekanan'
          ],
          correctAnswer: '2',
        ),
      ];
    } else if (moduleId == '2') {
      questions = <PostTestQuestionModel>[
        PostTestQuestionModel(
          id: 1,
          question:
              'Mengapa penting melakukan sinkronisasi generator sebelum dihubungkan ke jaringan listrik?',
          options: [
            'Untuk mengurangi panas berlebih',
            'Agar sistem SCADA dapat diaktifkan',
            'Supaya tidak terjadi arus balik dan gangguan sistem',
            'Untuk menstabilkan tekanan bahan bakar',
            'Agar transformator dapat bekerja maksimal'
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 2,
          question:
              'Jika prosedur startup generator tidak dilakukan sesuai SOP, apa risiko paling kritis yang mungkin terjadi?',
          options: [
            'Efisiensi meningkat tanpa kendali',
            'Sistem akan tetap berjalan tanpa gangguan',
            'Terjadinya lonjakan tegangan dan kerusakan peralatan',
            'Beban tidak dapat dialihkan',
            'Sistem pendingin akan mati otomatis'
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 3,
          question:
              'Mengapa operator perlu memantau parameter arus dan tegangan secara real-time saat sistem beroperasi?',
          options: [
            'Untuk menghitung rugi daya dengan cepat',
            'Supaya bisa menyalakan sistem otomatis',
            'Untuk mencegah ketidakseimbangan beban dan deteksi dini gangguan',
            'Agar sistem sinkronisasi berjalan cepat',
            'Untuk mengatur jumlah bahan bakar yang dikonsumsi'
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 4,
          question:
              'Bagaimana sistem pendingin berkontribusi dalam stabilitas operasional generator?',
          options: [
            'Mengatur voltase keluaran langsung',
            'Menghindari gangguan SCADA',
            'Menjaga suhu tetap stabil agar tidak merusak gulungan',
            'Meningkatkan arus induksi pada stator',
            'Mengurangi beban dari jaringan distribusi'
          ],
          correctAnswer: '0',
        ),
        PostTestQuestionModel(
          id: 5,
          question:
              'Mengapa sistem pemantauan berbasis SCADA sangat diperlukan dalam pengoperasian pembangkit modern?',
          options: [
            'Agar mesin tidak memerlukan operator',
            'Karena dapat mematikan sistem saat suhu tinggi',
            'Untuk monitoring dan pengendalian real-time yang akurat',
            'Supaya sistem bahan bakar tidak digunakan terlalu sering',
            'Untuk mengaktifkan turbin tanpa manual'
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 6,
          question:
              'Apa akibat jika sinkronisasi dilakukan saat frekuensi generator belum sesuai dengan jaringan?',
          options: [
            'Tidak ada pengaruh karena sistem otomatis',
            'Akan terjadi gangguan ringan pada sensor',
            'Terjadi arus lebih dan kerusakan peralatan',
            'Tegangan akan menyesuaikan sendiri',
            'SCADA akan memutus arus langsung'
          ],
          correctAnswer: '3',
        ),
        PostTestQuestionModel(
          id: 7,
          question:
              'Langkah apa yang paling tepat saat sistem mendeteksi suhu generator melebihi ambang batas?',
          options: [
            'Meningkatkan beban agar suhu turun',
            'Menunggu alarm berhenti secara otomatis',
            'Melakukan prosedur shutdown darurat dan pendinginan bertahap',
            'Menonaktifkan sensor suhu untuk sementara',
            'Menurunkan frekuensi kerja turbin'
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 8,
          question:
              'Apa indikator utama bahwa sinkronisasi generator ke jaringan berhasil dilakukan?',
          options: [
            'Tidak ada alarm aktif',
            'Frekuensi dan tegangan identik antara sistem dan jaringan',
            'Tegangan output lebih tinggi dari input',
            'SCADA menunjukkan warna hijau',
            'Generator berputar lebih cepat'
          ],
          correctAnswer: '1',
        ),
        PostTestQuestionModel(
          id: 9,
          question:
              'Dalam proses shutdown, mengapa beban perlu diturunkan secara bertahap?',
          options: [
            'Agar turbin tidak rusak saat berhenti',
            'Untuk menjaga kestabilan tegangan output',
            'Supaya transformator tidak terlalu panas',
            'Agar tekanan bahan bakar tetap rendah',
            'Untuk mempercepat proses pemadaman'
          ],
          correctAnswer: '1',
        ),
        PostTestQuestionModel(
          id: 10,
          question:
              'Apa peran prosedur Lock-Out Tag-Out (LOTO) saat perawatan sistem pembangkit?',
          options: [
            'Mengatur suhu sistem pendingin',
            'Mencegah aktifnya sistem saat perawatan dilakukan',
            'Mengaktifkan SCADA secara manual',
            'Meningkatkan efisiensi kerja motor listrik',
            'Mempercepat proses sinkronisasi'
          ],
          correctAnswer: '1',
        ),
        PostTestQuestionModel(
          id: 11,
          question:
              'Jika terjadi lonjakan arus tiba-tiba saat sistem bekerja normal, langkah awal yang harus dilakukan adalah...',
          options: [
            'Meningkatkan daya aktif pada generator',
            'Mengubah posisi transformator',
            'Memeriksa beban sistem dan identifikasi penyebab lonjakan',
            'Memutuskan semua koneksi distribusi',
            'Menurunkan tekanan bahan bakar'
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 12,
          question:
              'Apa fungsi utama HMI (Human Machine Interface) dalam pengoperasian sistem pembangkit?',
          options: [
            'Untuk mengontrol suhu lingkungan',
            'Sebagai media komunikasi antara operator dan sistem otomatis',
            'Menyimpan data backup mesin',
            'Mengatur distribusi bahan bakar',
            'Menghitung efisiensi sistem manual'
          ],
          correctAnswer: '1',
        ),
        PostTestQuestionModel(
          id: 13,
          question:
              'Mengapa sinkronisasi harus dilakukan dengan memperhatikan sudut fase generator?',
          options: [
            'Supaya sistem tetap beroperasi meski berbeda fase',
            'Agar arus dan tegangan bekerja tanpa gesekan',
            'Untuk mencegah arus transien yang merusak peralatan',
            'Karena sudut fase hanya berpengaruh pada frekuensi',
            'Untuk meningkatkan tekanan dari turbin'
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 14,
          question:
              'Bagaimana operator bisa mengetahui adanya ketidakseimbangan beban secara langsung?',
          options: [
            'Melalui sistem tekanan bahan bakar',
            'Melalui data sensor suhu turbin',
            'Melalui indikator arus tiap fasa pada sistem monitoring',
            'Dari rotasi kipas pendingin',
            'Melalui tingkat kebisingan ruang kontrol'
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 15,
          question:
              'Mengapa penting memiliki prosedur tertulis untuk startup dan shutdown sistem pembangkit?',
          options: [
            'Untuk mempercepat proses operasional',
            'Agar SCADA dapat dijalankan otomatis',
            'Untuk menjaga keselamatan kerja dan mencegah kesalahan teknis',
            'Agar operator dapat mengatur waktu kerja',
            'Supaya tidak perlu pelatihan ulang'
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 16,
          question:
              'Jika suhu sistem pendingin melebihi ambang batas, tindakan awal yang dilakukan adalah...',
          options: [
            'Menaikkan beban generator',
            'Mematikan sistem bahan bakar',
            'Memeriksa aliran pendingin dan menurunkan beban',
            'Menambahkan tekanan pada turbin',
            'Mengubah frekuensi sistem'
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 17,
          question:
              'Dalam sistem pembangkit, mengapa monitoring beban secara kontinyu sangat penting?',
          options: [
            'Untuk mematikan mesin secara otomatis',
            'Untuk meningkatkan tekanan oli',
            'Agar sistem dapat menyesuaikan suhu lingkungan',
            'Untuk mendeteksi ketidakseimbangan beban sebelum menimbulkan gangguan besar',
            'Agar bahan bakar tidak cepat habis'
          ],
          correctAnswer: '3',
        ),
        PostTestQuestionModel(
          id: 18,
          question:
              'Apa alasan utama penggunaan sinkronoskop dalam sistem pembangkit?',
          options: [
            'Untuk memantau suhu pendingin',
            'Untuk menurunkan arus secara otomatis',
            'Untuk memastikan generator dan jaringan sinkron dalam frekuensi dan sudut fase',
            'Untuk mengatur laju bahan bakar',
            'Untuk mengendalikan getaran pada turbin'
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 19,
          question:
              'Apa yang membedakan startup otomatis dan manual dalam pengoperasian pembangkit?',
          options: [
            'Startup manual hanya memerlukan sensor tekanan',
            'Startup otomatis memerlukan kontrol penuh dari HMI',
            'Startup otomatis terprogram dalam sistem SCADA dengan logika kondisi',
            'Startup manual dilakukan tanpa protokol apapun',
            'Startup otomatis tidak memerlukan sinkronisasi'
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 20,
          question:
              'Mengapa sistem proteksi otomatis seperti overload trip sangat krusial dalam sistem pembangkit?',
          options: [
            'Agar dapat menghentikan semua sensor',
            'Untuk mematikan HMI secara cepat',
            'Untuk mencegah kerusakan akibat beban lebih atau lonjakan arus',
            'Supaya sistem tetap berjalan tanpa operator',
            'Agar dapat mengontrol bahan bakar lebih banyak'
          ],
          correctAnswer: '2',
        ),
      ];
    } else if (moduleId == '3') {
      questions = <PostTestQuestionModel>[
        PostTestQuestionModel(
          id: 1,
          question:
              'Mengapa pemeliharaan preventif lebih efektif dibandingkan dengan pemeliharaan korektif dalam sistem pembangkit?',
          options: [
            'Karena lebih murah dalam jangka pendek',
            'Karena dilakukan saat mesin rusak',
            'Karena dapat mencegah kerusakan besar dan downtime',
            'Karena tidak perlu teknisi ahli',
            'Karena tidak membutuhkan dokumentasi',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 2,
          question:
              'Apa tujuan utama dari dokumentasi pemeliharaan rutin dalam pembangkit listrik?',
          options: [
            'Untuk pengarsipan data perusahaan',
            'Untuk keperluan akreditasi',
            'Untuk memastikan perawatan dilakukan tepat waktu dan mendeteksi pola kerusakan',
            'Untuk mempermudah penggantian operator',
            'Untuk digunakan dalam pelatihan teknisi baru',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 3,
          question:
              'Apa indikator bahwa sistem pelumasan generator tidak bekerja optimal?',
          options: [
            'Arus naik mendadak',
            'Tegangan meningkat drastis',
            'Suara gesekan meningkat dan suhu bearing naik',
            'Frekuensi turun tiba-tiba',
            'Tekanan oli turun di ruang kontrol',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 4,
          question:
              'Bagaimana predictive maintenance memberikan nilai tambah dalam operasional pembangkit?',
          options: [
            'Memungkinkan shutdown mendadak yang lebih aman',
            'Memberikan prediksi statistik tanpa inspeksi',
            'Mengurangi biaya darurat dengan mendeteksi kerusakan sebelum terjadi',
            'Menghilangkan kebutuhan inspeksi manual',
            'Menunda perbaikan hingga mesin benar-benar rusak',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 5,
          question:
              'Jika terjadi kebocoran oli pada transformator, langkah terbaik yang harus dilakukan adalah...',
          options: [
            'Menambahkan oli baru tanpa inspeksi',
            'Membersihkan bagian luar saja',
            'Menghentikan operasi dan melakukan perbaikan pada seal atau gasket',
            'Menurunkan beban secara drastis',
            'Memperkuat grounding sistem',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 6,
          question:
              'Apa peran utama checklist pemeliharaan dalam menjaga kinerja sistem pembangkit?',
          options: [
            'Sebagai laporan keuangan',
            'Untuk mengatur shift kerja',
            'Memastikan semua item diperiksa secara sistematis dan konsisten',
            'Untuk menggantikan sistem SCADA',
            'Untuk mempercepat pelumasan mesin',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 7,
          question:
              'Mengapa suhu bearing yang tinggi dapat menjadi tanda awal kerusakan sistem pelumasan?',
          options: [
            'Karena sistem pendingin gagal',
            'Karena tekanan pompa pelumas terlalu tinggi',
            'Karena pelumas tidak cukup atau tidak tersebar merata',
            'Karena frekuensi terlalu tinggi',
            'Karena bearing terlalu kecil untuk sistem',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 8,
          question:
              'Dalam sistem predictive maintenance, alat apa yang paling efektif mendeteksi getaran tidak normal?',
          options: [
            'Kamera termal',
            'Vibration sensor',
            'Sensor suhu digital',
            'Tachometer',
            'Manometer',
          ],
          correctAnswer: '1',
        ),
        PostTestQuestionModel(
          id: 9,
          question:
              'Mengapa pemeliharaan korektif harus disertai dengan analisis penyebab kerusakan?',
          options: [
            'Agar operator tidak mengulangi kesalahan',
            'Supaya mesin dapat dioperasikan lebih lama',
            'Untuk mencegah kerusakan serupa di masa depan',
            'Agar proses shutdown lebih cepat',
            'Untuk mengurangi jumlah personel teknis',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 10,
          question:
              'Apa risiko utama jika pemeliharaan tidak dilakukan secara berkala?',
          options: [
            'Tegangan naik secara perlahan',
            'Meningkatnya efisiensi mesin',
            'Terjadinya kerusakan mendadak dan downtime tinggi',
            'Suhu ruangan menjadi stabil',
            'SCADA tidak aktif',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 11,
          question:
              'Bagaimana thermal imaging dapat membantu dalam kegiatan pemeliharaan sistem pembangkit?',
          options: [
            'Mengukur kecepatan turbin',
            'Menentukan posisi rotor generator',
            'Mendeteksi titik panas abnormal pada peralatan listrik',
            'Menyesuaikan kapasitas bahan bakar',
            'Menghitung daya reaktif',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 12,
          question:
              'Apa fungsi utama dari CMMS (Computerized Maintenance Management System)?',
          options: [
            'Untuk mengatur shift kerja operator',
            'Menyimpan catatan keuangan pembangkit',
            'Mengelola jadwal dan riwayat pemeliharaan secara digital',
            'Mengendalikan laju aliran bahan bakar',
            'Meningkatkan tekanan sistem pendingin',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 13,
          question:
              'Kapan waktu terbaik untuk melakukan overhaul tahunan pada sistem pembangkit?',
          options: [
            'Saat beban sistem sedang puncak',
            'Saat sistem mengalami gangguan ringan',
            'Saat beban rendah untuk menghindari gangguan suplai',
            'Saat musim hujan untuk efisiensi turbin',
            'Saat suhu lingkungan tinggi',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 14,
          question:
              'Apa yang sebaiknya dilakukan saat indikator sistem menunjukkan adanya ketidakseimbangan arus pada transformator?',
          options: [
            'Meningkatkan daya aktif',
            'Mematikan pendingin oli',
            'Melakukan inspeksi koneksi kabel dan pembebanan fasa',
            'Mengurangi frekuensi operasi',
            'Mengganti turbin',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 15,
          question:
              'Apa manfaat utama dari prosedur troubleshooting yang terdokumentasi dengan baik?',
          options: [
            'Untuk mempercepat pengadaan suku cadang',
            'Agar pemeliharaan bisa ditunda',
            'Memudahkan teknisi dalam menangani kerusakan secara sistematis',
            'Untuk menghemat pelumas',
            'Menghindari audit berkala',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 16,
          question:
              'Mengapa pelumasan berlebihan juga dapat menimbulkan masalah pada mesin?',
          options: [
            'Karena menghambat arus listrik',
            'Karena meningkatkan suhu stator',
            'Karena menyebabkan tekanan internal berlebih dan kebocoran',
            'Karena mempercepat keausan bearing',
            'Karena menurunkan frekuensi kerja',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 17,
          question:
              'Apa hubungan antara kebersihan filter sistem pendingin dengan efisiensi kerja mesin?',
          options: [
            'Filter kotor membuat pelumas lebih encer',
            'Filter bersih menjaga aliran udara/air optimal untuk mencegah overheating',
            'Filter hanya berpengaruh pada suhu lingkungan',
            'Filter tidak mempengaruhi efisiensi',
            'Filter mengatur rotasi kipas turbin',
          ],
          correctAnswer: '1',
        ),
        PostTestQuestionModel(
          id: 18,
          question:
              'Apa penyebab umum gangguan pada sistem pelumasan generator?',
          options: [
            'Arus tidak stabil',
            'Tegangan terlalu tinggi',
            'Sumbatan pada saluran pelumas atau keausan pompa',
            'Turbin berputar terlalu cepat',
            'Suhu air pendingin menurun',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 19,
          question:
              'Mengapa inspeksi visual tetap penting meskipun sistem monitoring sudah otomatis?',
          options: [
            'Untuk mengganti alarm manual',
            'Karena visual lebih cepat dari digital',
            'Karena beberapa kerusakan tidak terdeteksi sensor',
            'Untuk mengatur data logger',
            'Karena operator wajib berjalan tiap jam',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 20,
          question:
              'Bagaimana prinsip kerja oil analysis dalam predictive maintenance?',
          options: [
            'Mendeteksi lonjakan tegangan pada generator',
            'Menganalisis kadar logam dan kontaminan untuk deteksi dini keausan komponen',
            'Mengatur suhu pelumas secara otomatis',
            'Mendeteksi getaran mekanik',
            'Mengukur tekanan udara dalam ruang oli',
          ],
          correctAnswer: '1',
        ),
      ];
    } else {
      questions = <PostTestQuestionModel>[
        PostTestQuestionModel(
          id: 1,
          question:
              'Mengapa penting memahami prinsip induksi elektromagnetik dalam sistem pembangkit?',
          options: [
            'Agar dapat mengendalikan suhu turbin',
            'Karena menentukan efisiensi sistem kontrol',
            'Karena menjadi dasar kerja generator dalam mengubah energi mekanik menjadi listrik',
            'Untuk menstabilkan tekanan bahan bakar',
            'Untuk mengontrol sistem pendingin otomatis',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 2,
          question:
              'Jika transformator mengalami ketidakseimbangan arus, tindakan pertama yang harus dilakukan adalah...',
          options: [
            'Mematikan sistem pendingin',
            'Meningkatkan daya reaktif',
            'Melakukan inspeksi kabel dan pembebanan tiap fasa',
            'Menurunkan frekuensi',
            'Mengganti oli pelumas',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 3,
          question:
              'Bagaimana sinkronoskop membantu dalam proses sinkronisasi generator?',
          options: [
            'Dengan mengatur tegangan output',
            'Mendeteksi arus bocor',
            'Menyesuaikan frekuensi dan sudut fase generator dengan jaringan',
            'Menstabilkan rotor turbin',
            'Mengukur efisiensi beban',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 4,
          question:
              'Apa risiko terbesar jika generator langsung dihubungkan ke jaringan tanpa sinkronisasi?',
          options: [
            'Terjadi fluktuasi suhu',
            'Meningkatkan efisiensi',
            'Gangguan besar berupa arus kejut dan kerusakan peralatan',
            'Tegangan menjadi stabil',
            'Arus berkurang secara drastis',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 5,
          question:
              'Mengapa SCADA sangat penting dalam sistem pembangkit modern?',
          options: [
            'Untuk memanaskan oli pelumas',
            'Untuk memonitor dan mengendalikan sistem secara real-time',
            'Mengatur waktu kerja operator',
            'Mengganti sensor manual',
            'Untuk menganalisis nilai ekonomi energi',
          ],
          correctAnswer: '1',
        ),
        PostTestQuestionModel(
          id: 6,
          question:
              'Salah satu fungsi dari sistem proteksi pembangkit adalah...',
          options: [
            'Meningkatkan faktor daya',
            'Memastikan kinerja operator',
            'Mendeteksi dan memutus sistem saat gangguan terjadi',
            'Mengurangi daya reaktif',
            'Mengatur efisiensi bahan bakar',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 7,
          question:
              'Manakah dari berikut ini yang termasuk sistem kendali otomatis dalam pembangkit?',
          options: [
            'Switch manual',
            'Pompa tangan',
            'PID Controller',
            'Panel distribusi',
            'Katup bypass',
          ],
          correctAnswer: '1',
        ),
        PostTestQuestionModel(
          id: 8,
          question: 'Salah satu keuntungan pemeliharaan prediktif adalah...',
          options: [
            'Mengurangi frekuensi pemeriksaan harian',
            'Mengurangi kebutuhan SCADA',
            'Mendeteksi potensi kerusakan sebelum terjadi kegagalan',
            'Mengabaikan data sensor',
            'Mengurangi penggunaan sensor',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 9,
          question:
              'Apa fungsi utama dari breaker (pemutus sirkuit) dalam sistem pembangkit?',
          options: [
            'Meningkatkan arus',
            'Menjaga tekanan bahan bakar',
            'Memutuskan arus listrik saat terjadi gangguan',
            'Mengalirkan gas buang',
            'Menurunkan tegangan ke nol',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 10,
          question:
              'Kapan operator harus melakukan sinkronisasi generator cadangan ke jaringan?',
          options: [
            'Ketika beban meningkat dan suplai utama tidak mencukupi',
            'Saat turbin dimatikan',
            'Ketika SCADA offline',
            'Setelah pergantian shift',
            'Ketika sistem pendingin aktif',
          ],
          correctAnswer: '1',
        ),
        PostTestQuestionModel(
          id: 11,
          question:
              'Apa perbedaan utama antara pemeliharaan preventif dan prediktif?',
          options: [
            'Preventif berdasarkan kondisi nyata mesin, prediktif berdasarkan jadwal',
            'Preventif dilakukan setelah kerusakan, prediktif sebelum kerusakan',
            'Preventif berdasarkan jadwal waktu tertentu, prediktif berdasarkan data kondisi peralatan',
            'Prediktif tidak membutuhkan alat ukur, preventif membutuhkan',
            'Preventif lebih murah dari prediktif',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 12,
          question:
              'Mengapa sistem pendingin sangat krusial dalam pembangkit listrik?',
          options: [
            'Untuk meningkatkan tekanan bahan bakar',
            'Agar turbin tidak bocor',
            'Mencegah overheating pada peralatan dan menjaga kinerja optimal',
            'Mengurangi beban operator',
            'Menurunkan efisiensi kerja mesin',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 13,
          question:
              'Bagaimana prinsip kerja oil analysis dalam predictive maintenance?',
          options: [
            'Mendeteksi lonjakan tegangan pada generator',
            'Menganalisis kadar logam dan kontaminan untuk deteksi dini keausan komponen',
            'Mengatur suhu pelumas secara otomatis',
            'Mendeteksi getaran mekanik',
            'Mengukur tekanan udara dalam ruang oli',
          ],
          correctAnswer: '1',
        ),
        PostTestQuestionModel(
          id: 14,
          question:
              'Manakah dari berikut ini termasuk parameter penting dalam monitoring sistem pembangkit?',
          options: [
            'Warna peralatan',
            'Jumlah operator',
            'Tegangan, arus, suhu, dan tekanan',
            'Lokasi geografis',
            'Jumlah kunjungan inspeksi',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 15,
          question:
              'Apa peran dari AVR (Automatic Voltage Regulator) dalam generator?',
          options: [
            'Mengatur suhu pendingin',
            'Mengatur kecepatan turbin',
            'Menjaga kestabilan tegangan output generator',
            'Menjaga arus sinkronisasi',
            'Mengatur distribusi daya beban',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 16,
          question:
              'Salah satu indikator perlunya pemeliharaan pada motor induksi adalah...',
          options: [
            'Warna kabel berubah',
            'Tegangan input stabil',
            'Getaran berlebihan dan suara abnormal',
            'Frekuensi tetap',
            'Putaran sesuai spesifikasi',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 17,
          question:
              'Dalam sistem pembangkit, alat ukur tachometer digunakan untuk...',
          options: [
            'Mengukur tekanan oli',
            'Mengukur frekuensi jaringan',
            'Mengukur kecepatan putar poros',
            'Mengukur suhu pendingin',
            'Mengukur kebisingan',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 18,
          question:
              'Mengapa penting melakukan inspeksi berkala pada sistem kelistrikan pembangkit?',
          options: [
            'Untuk meningkatkan jumlah tenaga kerja',
            'Agar turbin bekerja lebih cepat',
            'Untuk mencegah kerusakan dini dan memastikan keselamatan',
            'Mengurangi tegangan jaringan',
            'Menurunkan arus beban',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 19,
          question: 'Apa akibat dari kegagalan sistem pelumasan dalam turbin?',
          options: [
            'Terjadi peningkatan daya',
            'Putaran menjadi lebih stabil',
            'Terjadi keausan cepat dan potensi kerusakan besar',
            'Efisiensi meningkat',
            'Arus berkurang secara drastis',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 20,
          question:
              'Bagaimana prinsip kerja oil analysis dalam predictive maintenance?',
          options: [
            'Mendeteksi lonjakan tegangan pada generator',
            'Menganalisis kadar logam dan kontaminan untuk deteksi dini keausan komponen',
            'Mengatur suhu pelumas secara otomatis',
            'Mendeteksi getaran mekanik',
            'Mengukur tekanan udara dalam ruang oli',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 21,
          question:
              'Mengapa inspeksi visual tetap dibutuhkan meskipun ada sistem monitoring otomatis?',
          options: [
            'Karena operator wajib berjalan keliling',
            'Karena sensor digital tidak memerlukan kalibrasi',
            'Karena tidak semua kerusakan dapat terdeteksi sensor',
            'Untuk mengganti mode SCADA manual',
            'Untuk menyalakan turbin secara langsung',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 22,
          question:
              'Apa efek dari filter sistem pendingin yang tersumbat dalam sistem pembangkit?',
          options: [
            'Sistem SCADA aktif otomatis',
            'Overheating pada komponen karena sirkulasi terganggu',
            'Meningkatkan efisiensi turbin',
            'Menurunkan frekuensi arus',
            'Meningkatkan tekanan sistem pelumasan',
          ],
          correctAnswer: '1',
        ),
        PostTestQuestionModel(
          id: 23,
          question:
              'Bagaimana pengaruh ketidakseimbangan beban terhadap generator sinkron?',
          options: [
            'Menurunkan tekanan uap',
            'Mempercepat pelumasan otomatis',
            'Menyebabkan arus dan tegangan tidak stabil',
            'Mengurangi efisiensi bahan bakar',
            'Menurunkan efisiensi rotor turbin',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 24,
          question:
              'Mengapa penting memahami alur konversi energi dalam sistem pembangkit?',
          options: [
            'Supaya bisa membuat instalasi rumah tangga',
            'Untuk mengganti sistem proteksi',
            'Agar dapat memetakan jalur energi dan menentukan titik efisiensi',
            'Agar dapat mengatur tekanan bahan bakar',
            'Untuk menjaga suhu tetap konstan',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 25,
          question:
              'Jika suhu bearing terus meningkat saat operasi, apa indikasi yang paling logis?',
          options: [
            'Tekanan uap meningkat',
            'Frekuensi generator menurun',
            'Sistem pelumasan tidak berjalan dengan baik',
            'Pendingin air terlalu dingin',
            'Tegangan keluar stabil',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 26,
          question:
              'Bagaimana CMMS membantu dalam pengambilan keputusan teknis?',
          options: [
            'Menyediakan data audit keuangan',
            'Menampilkan alarm turbin',
            'Memberikan histori pemeliharaan dan efektivitas tindakan teknis',
            'Meningkatkan kapasitas beban',
            'Menyinkronkan generator otomatis',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 27,
          question:
              'Kapan waktu yang paling aman untuk inspeksi transformator?',
          options: [
            'Saat suhu oli sangat tinggi',
            'Ketika sistem sedang shutdown dan bebas beban',
            'Saat sistem pendingin mati',
            'Ketika beban penuh aktif',
            'Saat suhu lingkungan ekstrem',
          ],
          correctAnswer: '1',
        ),
        PostTestQuestionModel(
          id: 28,
          question:
              'Mengapa sistem pendingin air harus dipantau secara berkala?',
          options: [
            'Untuk mempercepat rotasi turbin',
            'Untuk mencegah tekanan oli turun',
            'Karena overheating bisa menyebabkan kerusakan isolasi listrik',
            'Agar tegangan tetap tinggi',
            'Untuk menambah arus induksi',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 29,
          question:
              'Apa alasan utama operator menggunakan thermal camera selama pemeliharaan?',
          options: [
            'Untuk menyetel ulang SCADA',
            'Untuk mendeteksi kebocoran bahan bakar',
            'Untuk memantau suhu berlebih pada komponen sistem',
            'Untuk mempercepat start-up',
            'Untuk mematikan alarm secara manual',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 30,
          question: 'Mengapa overload trip harus diuji secara berkala?',
          options: [
            'Agar bisa mendeteksi tegangan DC',
            'Untuk melihat reaksi sensor suhu',
            'Supaya sistem dapat menghentikan beban berlebih secara otomatis saat diperlukan',
            'Untuk menonaktifkan sensor getaran',
            'Agar pelumasan bekerja optimal',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 31,
          question:
              'Bagaimana prinsip kerja sistem sinkronisasi dalam generator?',
          options: [
            'Menyamakan kecepatan rotor dan beban mekanis',
            'Menyamakan frekuensi, tegangan, dan sudut fase antara generator dan jaringan',
            'Mengatur suhu oli dan air pendingin',
            'Menyeimbangkan tekanan bahan bakar',
            'Menurunkan kecepatan sistem SCADA',
          ],
          correctAnswer: '1',
        ),
        PostTestQuestionModel(
          id: 32,
          question:
              'Apa akibat dari frekuensi output generator tidak sesuai dengan sistem jaringan?',
          options: [
            'Tegangan meningkat drastis',
            'Suhu sistem pendingin turun',
            'Terjadi arus bolak-balik tidak sinkron yang bisa merusak sistem',
            'Beban listrik langsung meningkat',
            'Tekanan oli meningkat',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 33,
          question:
              'Mengapa pelumasan berlebihan juga dapat menyebabkan kerusakan?',
          options: [
            'Menyebabkan gesekan berlebih',
            'Menurunkan daya output',
            'Menimbulkan tekanan internal dan kebocoran seal',
            'Membuat SCADA overload',
            'Mengurangi efisiensi motor',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 34,
          question: 'Apa tujuan utama dari predictive maintenance?',
          options: [
            'Meningkatkan downtime mesin',
            'Mendeteksi kerusakan saat mesin rusak total',
            'Mengantisipasi kegagalan komponen sebelum terjadi kerusakan',
            'Mengurangi kebutuhan pelumasan',
            'Mengganti sistem proteksi otomatis',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 35,
          question:
              'Apa peran penting data logger dalam sistem monitoring pembangkit?',
          options: [
            'Menyimpan alarm suara',
            'Menyimpan histori pengukuran untuk analisis performa',
            'Menyesuaikan SCADA secara manual',
            'Menurunkan suhu pendingin',
            'Mendeteksi arus induksi',
          ],
          correctAnswer: '1',
        ),
        PostTestQuestionModel(
          id: 36,
          question: 'Mengapa suhu oli pelumas harus dijaga dalam batas aman?',
          options: [
            'Agar menghasilkan listrik lebih banyak',
            'Untuk mempercepat pelumasan',
            'Untuk mencegah degradasi kualitas pelumas dan kerusakan bearing',
            'Untuk menambah tekanan uap',
            'Agar pendingin tetap stabil',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 37,
          question:
              'Apa keunggulan utama sistem SCADA dalam pemeliharaan modern?',
          options: [
            'Tidak memerlukan operator',
            'Menonaktifkan sensor suhu',
            'Menyediakan kontrol dan data real-time yang mendukung pengambilan keputusan cepat',
            'Mengganti sensor tekanan',
            'Menurunkan suhu rotor',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 38,
          question:
              'Bagaimana prosedur troubleshooting yang sistematis dapat membantu pemeliharaan?',
          options: [
            'Menyimpan suku cadang',
            'Mengurangi inspeksi visual',
            'Memudahkan identifikasi masalah dan penentuan tindakan perbaikan',
            'Menghentikan SCADA otomatis',
            'Mengatur ulang rotasi turbin',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 39,
          question:
              'Mengapa ketidakseimbangan fasa bisa membahayakan transformator?',
          options: [
            'Membuat generator lebih efisien',
            'Mengurangi rotasi turbin',
            'Menyebabkan panas berlebih dan kerusakan isolasi',
            'Menurunkan tekanan pelumas',
            'Mengubah frekuensi kerja SCADA',
          ],
          correctAnswer: '2',
        ),
        PostTestQuestionModel(
          id: 40,
          question:
              'Apa peran sistem proteksi arus lebih (overcurrent protection)?',
          options: [
            'Menjaga kestabilan suhu',
            'Meningkatkan daya reaktif',
            'Mencegah kerusakan akibat arus berlebih',
            'Mengatur rotasi kipas',
            'Menurunkan beban pompa',
          ],
          correctAnswer: '2',
        ),
      ];
    }
    this.questions = questions;
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

  Future<void> onSubmitTest(String moduleId) async {
    if (state is PostTestLoaded) {
      int correctAnswers = 0;
      answers.forEach((index, answer) {
        if (answer == questions[index].correctAnswer) {
          correctAnswers++;
        }
      });
      /// Sum score post test
      int score = 0;
      if(moduleId == '4'){
        score = (correctAnswers * 2.5).round();
      } else {
        score = correctAnswers * 5;
      }

      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid') ?? '';
      final currentModule = '$uid-module-$moduleId';

      // INFO : update MODULE data
      final moduleRef = _firestore.collection('modules').doc(currentModule);
      await _firestore.runTransaction((transaction) async {
        final moduleSnapshot = await transaction.get(moduleRef);

        if (moduleSnapshot.exists) {
          if (score >= 75) {
            transaction.update(moduleRef, {
              'is_finish': true,
              'point_post_test': score,
            });
            if (int.parse(moduleId) < 4) {
              final nextModule = (int.parse(moduleId) + 1).toString();
              final nextModuleRef = _firestore
                  .collection('modules')
                  .doc('$uid-module-$nextModule');
              await _firestore.runTransaction((transaction) async {
                final nextModuleSnapshot = await transaction.get(nextModuleRef);

                if (nextModuleSnapshot.exists) {
                  transaction.update(
                      nextModuleRef, {'is_finish': false, 'is_locked': false});
                }
              });
            }
          } else {
            transaction.update(moduleRef, {
              'is_finish': false,
              'point_post_test': score,
            });
          }
        }
      });

      // INFO : update USER total progress
      final userRef = _firestore.collection('users').doc(uid);

      if (score >= 75) {
        await _firestore.runTransaction((transaction) async {
          final userSnapshot = await transaction.get(userRef);

          if (userSnapshot.exists) {
            transaction.update(userRef, {
              'point_post_test': score,
              'total_progress': userSnapshot.data()?['total_progress'] + 25,
            });
            await prefs.setInt(
                'totalProgress', userSnapshot.data()?['total_progress'] + 25);
          }
        });
      } else {
        //INFO : jika nilai kurang dari 75, total progress tidak bertambah
        //INFO : jika nilai kurang dari 75, is_finish = false
        final userRef = _firestore.collection('users').doc(uid);

        await _firestore.runTransaction((transaction) async {
          final userSnapshot = await transaction.get(userRef);

          if (userSnapshot.exists) {
            transaction.update(userRef, {
              'point_post_test': score,
              'total_progress': userSnapshot.data()?['total_progress'],
            });
            await prefs.setInt(
                'totalProgress', userSnapshot.data()?['total_progress']);
          }
        });
      }

      emit(PostTestComplete(
        isSuccess: score >= 75,
        point: score,
      ));
    }
  }
}
