import 'package:flutter/material.dart';
import 'package:powergen_edu/src/features/modules/module_detail_page.dart';

class ModulesPage extends StatelessWidget {
  const ModulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data progress (nantinya bisa diambil dari state management/API)
    const double progressPercentage = 50.0;

    // Data modul (nantinya bisa diambil dari API)
    final List<Map<String, dynamic>> modules = [
      {
        'id': 1,
        'title':
            'Konsep Dasar Mesin Listrik Pembangkit dan Peralatan Mekanis Pembangkit',
        'isCompleted': true,
        'isLocked': false,
      },
      {
        'id': 2,
        'title':
            'Pengoperasian Mesin Listrik Pembangkit dan Peralatan Mekanis Pembangkit',
        'isCompleted': false,
        'isLocked': false,
      },
      {
        'id': 3,
        'title':
            'Pemeliharaan Mesin Listrik Pembangkit dan Peralatan Mekanis Pembangkit',
        'isCompleted': false,
        'isLocked': true,
      },
      {
        'id': 4,
        'title':
            'Sistem Pemeliharaan dan Pengoperasian Mesin Listrik Pembangkit',
        'isCompleted': false,
        'isLocked': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Modul'),
      ),
      body: Column(
        children: [
          // Progress Section
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress Kamu ${progressPercentage.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progressPercentage / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                ),
              ],
            ),
          ),

          // Modules List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: modules.length,
              itemBuilder: (context, index) {
                final module = modules[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: module['isCompleted']
                          ? Colors.deepOrange
                          : module['isLocked']
                              ? Colors.grey
                              : Colors.deepOrange[300],
                      child: Icon(
                        module['isCompleted']
                            ? Icons.check
                            : module['isLocked']
                                ? Icons.lock
                                : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      index == 3
                          ? 'Final Project: ${module['title']}'
                          : 'Bab ${module['id']}: ${module['title']}',
                      style: TextStyle(
                        color: module['isLocked'] ? Colors.grey : Colors.black,
                      ),
                    ),
                    onTap: module['isLocked']
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Selesaikan modul sebelumnya terlebih dahulu'),
                              ),
                            );
                          }
                        : () {
                            // Navigate to module detail page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ModuleDetailPage(
                                  id: module['id'],
                                  title: module['title'],
                                ),
                              ),
                            );
                          },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
