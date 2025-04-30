import 'package:flutter/material.dart';
import 'package:powergen_edu/src/features/modules/models/module_model.dart';
import 'package:powergen_edu/src/features/modules/module_detail_page.dart';

class ModulesPage extends StatelessWidget {
  final List<ModuleModel> modules;
  final int percentage;

  const ModulesPage({
    super.key,
    required this.modules,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
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
                  'Progress Kamu ${percentage.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: percentage / 100,
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
                      backgroundColor: module.isLocked
                          ? Colors.grey
                          : Colors.deepOrange[300],
                      child: Icon(
                        module.isLocked ? Icons.lock : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      '${module.title} : \n${module.description ?? ''}',
                      style: TextStyle(
                        color: module.isLocked ? Colors.grey : Colors.black,
                      ),
                    ),
                    onTap: module.isLocked
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
                                  id: module.idModule ?? 0,
                                  title: module.title ?? '',
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
