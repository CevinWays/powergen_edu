import 'package:flutter/material.dart';

class ModuleDetailPage extends StatelessWidget {
  final int id;
  final String title;

  const ModuleDetailPage({super.key, required this.id, required this.title});

  @override
  Widget build(BuildContext context) {
    // Contoh data konten (nantinya bisa dari API)
    final List<Map<String, dynamic>> contents = [
      {
        'type': 'text',
        'content': 'Text and Multimedia Content',
        'isTitle': true,
      },
      {
        'type': 'text',
        'content':
            'Basic concepts of electrical machinery, types of electrical machinery used in power generation, and basic working principles. An in-depth discussion of the components of power plant machinery, their functions, and how each component interacts. An in-depth discussion of the components of power plant machinery, their functions, and how each component interacts.',
        'isTitle': false,
      },
      {
        'type': 'image',
        'content': 'assets/images/machinery1.jpg', // Sesuaikan path image
      },
      {
        'type': 'text',
        'content':
            'An in-depth discussion of the components of power plant machinery, their functions, and how each component interacts.',
        'isTitle': false,
      },
      {
        'type': 'image',
        'content': 'assets/images/machinery2.jpg', // Sesuaikan path image
      },
      {
        'type': 'text',
        'content': 'Exercise',
        'isTitle': true,
      },
      {
        'type': 'text',
        'content':
            'Multiple-choice and open-ended questions to test students\' basic understanding.',
        'isTitle': false,
      },
      {
        'type': 'text',
        'content': 'Interactive Multimedia Features',
        'isTitle': true,
      },
      {
        'type': 'text',
        'content':
            'Interactive diagrams, animated videos, and illustrative drawings to explain basic concepts.',
        'isTitle': false,
      },
      {
        'type': 'image',
        'content': 'assets/images/interactive1.jpg', // Sesuaikan path image
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Chapter $id'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: contents.map((content) {
                    if (content['type'] == 'text') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          content['content'],
                          style: content['isTitle'] == true
                              ? Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )
                              : Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    } else if (content['type'] == 'image') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            content['content'],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.image_not_supported,
                              color: Colors.red,
                              size: 50,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }).toList(),
                ),
              ),
            ),
          ),
          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle previous navigation
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Kembali'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle next navigation
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Selanjutnya'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
