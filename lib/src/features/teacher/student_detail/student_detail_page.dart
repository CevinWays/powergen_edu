import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../teacher_home/models/teacher_home_models.dart';

class StudentDetailPage extends StatelessWidget {
  final StudentProgress student;

  const StudentDetailPage({
    super.key,
    required this.student,
  });

  Future<void> _openPDF(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Siswa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Siswa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Nama'),
                      subtitle: Text(student.fullName ?? '-'),
                      leading: const Icon(Icons.person),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: const Text('NIS'),
                      subtitle: Text(student.nis),
                      leading: const Icon(Icons.school),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Learning Progress Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progress Belajar Siswa',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Progress'),
                      subtitle: Text('${student.progressPercentage}%'),
                      leading: const Icon(Icons.assessment),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Uploaded PDFs Card
            Card(
              child: Padding(
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
                          .where('userId', isEqualTo: student.id)
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

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                                'Belum ada dokumen praktikum yang diunggah'),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final doc = snapshot.data!.docs[index];
                            final data = doc.data() as Map<String, dynamic>;
                            return ListTile(
                              leading: const Icon(Icons.picture_as_pdf),
                              title: Text(data['fileName'] ?? 'Unnamed PDF'),
                              subtitle: Text(data['uploadedAt'] != null
                                  ? (data['uploadedAt'] as Timestamp)
                                      .toDate()
                                      .toString()
                                  : 'Date unknown'),
                              trailing: IconButton(
                                icon: const Icon(Icons.open_in_new),
                                onPressed: () => _openPDF(data['downloadUrl']),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
