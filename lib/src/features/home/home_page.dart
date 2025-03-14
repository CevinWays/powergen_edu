import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powergen_edu/src/features/modules/modules_page.dart';
import '../progress/progress_page.dart';
import '../profile/profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeData()),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
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
                        const Text(
                          'Halo, Indira',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
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

                  // Progress indicator
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     const Text(
                  //       'Rata-rata Progress 50% :',
                  //       style: TextStyle(
                  //         color: Colors.grey,
                  //       ),
                  //     ),
                  //     const SizedBox(height: 8),
                  //     LinearProgressIndicator(
                  //       value: 0.5,
                  //       minHeight: 10,
                  //       borderRadius:
                  //           const BorderRadius.all(Radius.circular(10.0)),
                  //       backgroundColor: Colors.grey[200],
                  //       valueColor: AlwaysStoppedAnimation<Color>(
                  //         Colors.deepOrange[500]!,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // const SizedBox(height: 24),

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
                                value: 0.6,
                                backgroundColor: Colors.grey[200],
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.deepOrange),
                                strokeWidth: 8,
                              ),
                            ),
                            const Text(
                              '60%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Module Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bab 1: Fundamentals of Power Generation',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Module 06/10',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              // Continue Button
                              ElevatedButton(
                                onPressed: () {
                                  // Add navigation logic here
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
                        ),
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
                          value: '12',
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          icon: Icons.pending_outlined,
                          label: 'Dikerjakan',
                          value: '3',
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          icon: Icons.check_circle_outline,
                          label: 'Selesai',
                          value: '5',
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Menu Grid with 4 buttons
                  // GridView.count(
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   crossAxisCount: 2,
                  //   mainAxisSpacing: 16,
                  //   crossAxisSpacing: 16,
                  //   children: [
                  //     _buildMenuButton(
                  //       icon: Icons.play_circle_outline,
                  //       label: 'Mulai Modul',
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => const ModulesPage(),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //     _buildMenuButton(
                  //       icon: Icons.note_alt_outlined,
                  //       label: 'Catatan',
                  //       onTap: () {},
                  //     ),
                  //     _buildMenuButton(
                  //       icon: Icons.assignment_outlined,
                  //       label: '',
                  //       onTap: () {},
                  //     ),
                  //     _buildMenuButton(
                  //       icon: Icons.architecture_outlined,
                  //       label: 'Praktikum',
                  //       onTap: () {},
                  //     ),
                  //   ],
                  // ),

                  // const SizedBox(height: 24),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    builder: (context) => const ModulesPage()),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_circle_right_outlined,
                                  color: Colors.deepOrange[300],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 300,
                        child: BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state) {
                            if (state is HomeLoading) {
                              return const Center(
                                  child: CupertinoActivityIndicator());
                            }
                            if (state is HomeLoaded) {
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.modules.length,
                                itemBuilder: (context, index) {
                                  final module = state.modules[index];
                                  return Container(
                                    width: 280,
                                    margin: EdgeInsets.only(
                                      left: index == 0 ? 0 : 16,
                                      right: index == state.modules.length - 1
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
                                                  backgroundColor: module
                                                          .isCompleted
                                                      ? Colors.deepOrange
                                                      : module.isLocked
                                                          ? Colors.grey
                                                          : Colors
                                                              .deepOrange[300],
                                                  child: Icon(
                                                    module.isCompleted
                                                        ? Icons.check
                                                        : module.isLocked
                                                            ? Icons.lock
                                                            : Icons.play_arrow,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    'Chapter ${module.id}',
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              module.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              module.description,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
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
                                                  '${module.estimatedHours} Jam Belajar',
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
                                  );
                                },
                              );
                            }
                            if (state is HomeError) {
                              return Center(child: Text(state.message));
                            }
                            return const SizedBox();
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
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: 70,
                                color: Colors.deepOrange[100]!,
                                title: '70%',
                                radius: 60,
                                titleStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value: 45,
                                color: Colors.deepOrange[200]!,
                                title: '45%',
                                radius: 60,
                                titleStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value: 55,
                                color: Colors.deepOrange[300]!,
                                title: '55%',
                                radius: 60,
                                titleStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // const Text(
                      //   'Module Progress',
                      //   style: TextStyle(
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      _buildModuleProgress(
                        'Module 1: Basics of Power Generation',
                        70,
                        Colors.deepOrange[500]!,
                      ),
                      const SizedBox(height: 16),
                      _buildModuleProgress(
                        'Module 2: Advanced Machinery',
                        45,
                        Colors.deepOrange[500]!,
                      ),
                      const SizedBox(height: 16),
                      _buildModuleProgress(
                        'Module 3: Safety Protocols',
                        55,
                        Colors.deepOrange[500]!,
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
      ),
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
