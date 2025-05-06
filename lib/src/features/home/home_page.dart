import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:powergen_edu/src/features/modules/module_detail_page.dart';
import 'package:powergen_edu/src/features/modules/modules_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../profile/profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _openPDF(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

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
      create: (context) => HomeBloc()..add(LoadHomeData()),
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(LoadHomeData());
                },
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Customer name and profile row
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfilePage(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/icon/icon.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'Halo, ${state.username}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.grey[200],
                                  radius: 24,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Last Module Checkpoint Section
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.deepOrange[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Progress Circle
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: CircularProgressIndicator(
                                        value: double.parse(
                                            ((state.totalProgress ?? 0) / 100)
                                                .toString()),
                                        backgroundColor: Colors.grey[200],
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Colors.deepOrange),
                                        strokeWidth: 8,
                                      ),
                                    ),
                                    Text(
                                      '${state.totalProgress}%',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                // Module Info
                                _buildCurrentModule(context),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Summary Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _buildSummaryItem(
                                  icon: Icons.book_outlined,
                                  label: 'Total',
                                  value: (state.totalModules ?? 0).toString(),
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: _buildSummaryItem(
                                  icon: Icons.pending_outlined,
                                  label: 'Dikerjakan',
                                  value: (state.totalInProgressModules ?? 0)
                                      .toString(),
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: _buildSummaryItem(
                                  icon: Icons.check_circle_outline,
                                  label: 'Selesai',
                                  value: (state.totalFinishModules ?? 0)
                                      .toString(),
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Uploaded PDFs Card
                          Visibility(
                            visible: state.lastModule.idModule == 4,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Dokumen Praktikum',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('student_pdfs')
                                        .where('userId', isEqualTo: state.uid)
                                        .orderBy('uploadedAt', descending: true)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            'Terjadi kesalahan saat memuat data');
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }

                                      if (!snapshot.hasData ||
                                          snapshot.data!.docs.isEmpty) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: IconButton(
                                                onPressed: () async {
                                                  await _uploadPDF(context);
                                                  if (context.mounted) {
                                                    context
                                                        .read<HomeBloc>()
                                                        .add(LoadHomeData());
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.upload_file,
                                                  size: 60,
                                                ),
                                                color: Colors.blue[300],
                                              ),
                                            ),
                                            const Text(
                                              'Belum ada dokumen praktikum yang diunggah, ketuk untuk mengunggah',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        );
                                      }

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          final doc =
                                              snapshot.data!.docs[index];
                                          final data = doc.data()
                                              as Map<String, dynamic>;
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                leading: const Icon(
                                                  Icons.picture_as_pdf,
                                                  color: Colors.blue,
                                                ),
                                                title: Text(data['fileName'] ??
                                                    'Unnamed PDF'),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(data['uploadedAt'] !=
                                                            null
                                                        ? (data['uploadedAt']
                                                                as Timestamp)
                                                            .toDate()
                                                            .toString()
                                                        : 'Date unknown'),
                                                    const SizedBox(height: 8),
                                                    if (data['review'] !=
                                                            null &&
                                                        data['review'] != '')
                                                      Text(
                                                        'Catatan dari Guru : ${data['review']}',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                trailing: IconButton(
                                                  icon: const Icon(
                                                      Icons.open_in_new),
                                                  onPressed: () => _openPDF(
                                                      data['downloadUrl']),
                                                ),
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Penilaian',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Informasi Penilaian'),
                                                            content: const Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    '⭐ 1 Bintang: Sangat Buruk'),
                                                                Text(
                                                                    '⭐⭐ 2 Bintang: Buruk'),
                                                                Text(
                                                                    '⭐⭐⭐ 3 Bintang: Cukup'),
                                                                Text(
                                                                    '⭐⭐⭐⭐ 4 Bintang: Baik'),
                                                                Text(
                                                                    '⭐⭐⭐⭐⭐ 5 Bintang: Sangat Baik'),
                                                              ],
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Tutup'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.info_outline,
                                                      color: Colors.blue,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: List.generate(
                                                  data['pointPraktikum'] ?? 0,
                                                  (index) => const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 50,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Menu Grid with 4 buttons
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Modul Belajar',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ModulesPage(
                                              modules: state.modules ?? [],
                                              percentage:
                                                  state.totalProgress ?? 0,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Lihat semua'))
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 250,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.modules?.length,
                                  itemBuilder: (context, index) {
                                    final module = state.modules?[index];
                                    return GestureDetector(
                                      onTap: module?.isLocked ?? false
                                          ? () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Selesaikan modul sebelumnya terlebih dahulu'),
                                                ),
                                              );
                                            }
                                          : () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ModuleDetailPage(
                                                    id: module?.idModule ?? 0,
                                                    title: module?.title ?? '',
                                                    isFinish:
                                                        module?.isFinish ??
                                                            false,
                                                    pointPostTest:
                                                        module?.pointPostTest ??
                                                            0,
                                                    desc: module?.description,
                                                  ),
                                                ),
                                              );
                                            },
                                      child: Container(
                                        width: 280,
                                        margin: EdgeInsets.only(
                                          left: index == 0 ? 0 : 16,
                                          right: index ==
                                                  (state.modules?.length ?? 0) -
                                                      1
                                              ? 0
                                              : 0,
                                        ),
                                        child: Card(
                                          elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor: (module
                                                                  ?.isLocked ??
                                                              false)
                                                          ? Colors.grey
                                                          : (module?.isFinish ??
                                                                  false)
                                                              ? Colors
                                                                  .green[300]
                                                              : Colors.deepOrange[
                                                                  300],
                                                      child: Icon(
                                                        (module?.isLocked ??
                                                                false)
                                                            ? Icons.lock
                                                            : (module?.isFinish ??
                                                                    false)
                                                                ? Icons.check
                                                                : Icons
                                                                    .play_arrow,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        module?.title ?? '',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  module?.description ?? '',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const Spacer(),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.access_time,
                                                      size: 16,
                                                      color: Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${module?.estimatedHours} Jam Belajar',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 32,
                              ),
                              const Text(
                                'Progress',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // const SizedBox(height: 20),
                              // SizedBox(
                              //   height: 200,
                              //   child: PieChart(
                              //     PieChartData(
                              //       sections: [
                              //         PieChartSectionData(
                              //           value: 70,
                              //           color: Colors.deepOrange[100]!,
                              //           title: '70%',
                              //           radius: 60,
                              //           titleStyle: const TextStyle(
                              //             fontSize: 16,
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.white,
                              //           ),
                              //         ),
                              //         PieChartSectionData(
                              //           value: 45,
                              //           color: Colors.deepOrange[200]!,
                              //           title: '45%',
                              //           radius: 60,
                              //           titleStyle: const TextStyle(
                              //             fontSize: 16,
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.white,
                              //           ),
                              //         ),
                              //         PieChartSectionData(
                              //           value: 55,
                              //           color: Colors.deepOrange[300]!,
                              //           title: '55%',
                              //           radius: 60,
                              //           titleStyle: const TextStyle(
                              //             fontSize: 16,
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.white,
                              //           ),
                              //         ),
                              //       ],
                              //       sectionsSpace: 0,
                              //       centerSpaceRadius: 40,
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(height: 40),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.modules?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final module = state.modules![index];
                                  return Column(
                                    children: [
                                      _buildModuleProgress(
                                        '${module.title}: ${module.description}',
                                        module.isFinish ? 100 : 0,
                                        Colors.deepOrange[500]!,
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            if (state is HomeError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: (index) {
      //     switch (index) {
      //       case 0:
      //         // Home - already on home page
      //         break;
      //       case 1:
      //         // Progress
      //         Navigator.pushReplacement(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => const ProgressPage(),
      //           ),
      //         );
      //         break;
      //       case 2:
      //         // Profile
      //         Navigator.pushReplacement(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => const ProfilePage(),
      //           ),
      //         );
      //         break;
      //     }
      //   },
      //   currentIndex: 0,
      //   selectedItemColor: Colors.deepOrange[300],
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.home_outlined,
      //       ),
      //       label: 'Beranda',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.trending_up_outlined),
      //       label: 'Progres',
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildCurrentModule(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded && state.lastModule.idModule != 0) {
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${state.lastModule?.title} : ${state.lastModule?.description}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Continue Button
                ElevatedButton(
                  onPressed: state.lastModule?.isLocked ?? false
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Selesaikan modul sebelumnya terlebih dahulu'),
                            ),
                          );
                        }
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModuleDetailPage(
                                id: state.lastModule?.idModule ?? 0,
                                title: state.lastModule?.title ?? '',
                                isFinish: state.lastModule?.isFinish ?? false,
                                pointPostTest:
                                    state.lastModule?.pointPostTest ?? 0,
                                desc: state.lastModule?.description,
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Expanded(
            child: Text(
              'Belum ada modul yang dikerjakan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.deepOrange[50],
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Colors.deepOrange[300],
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.deepOrange[300],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleProgress(String title, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$progress%',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Add this new method for summary items
  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
