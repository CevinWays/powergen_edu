import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powergen_edu/src/features/login/login_page.dart';
import 'package:powergen_edu/src/features/teacher/student_detail/student_detail_page.dart';
import './bloc/teacher_home_bloc.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeacherHomeBloc()..add(LoadTeacherHomeData()),
      child: Builder(
        builder: (context) {
          return BlocConsumer<TeacherHomeBloc, TeacherHomeState>(
            listener: (context, state) {
              if (state is TeacherHomeError && !state.isRetryable) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (state is LogoutSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logout berhasil!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Dashboard Guru'),
                  leadingWidth: 0,
                  leading: const SizedBox.shrink(),
                  actions: [
                    IconButton(
                        onPressed: () {
                          context.read<TeacherHomeBloc>().add(Logout());
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        )),
                  ],
                ),
                body: _buildBody(context, state),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, TeacherHomeState state) {
    if (state is TeacherHomeLoading && state.isInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is TeacherHomeError && state.isRetryable) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<TeacherHomeBloc>().add(LoadTeacherHomeData());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is TeacherHomeLoaded) {
      return Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              context.read<TeacherHomeBloc>().add(LoadTeacherHomeData());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari Murid...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        context
                            .read<TeacherHomeBloc>()
                            .add(SearchStudents(value));
                      },
                    ),
                    const SizedBox(height: 16),

                    // Student Progress Overview Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Progres Belajar Siswa',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.studentProgress.length,
                              itemBuilder: (context, index) {
                                final progress = state.studentProgress[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StudentDetailPage(
                                            student: progress),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(8.0),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blue[100],
                                      child: Text(
                                        progress.fullName?[0]
                                                .toUpperCase() ??
                                            '',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(progress.fullName ?? ''),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        LinearProgressIndicator(
                                          value: (progress.progressPercentage ??
                                                  0) /
                                              100,
                                          backgroundColor: Colors.grey[200],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            (progress.progressPercentage ?? 0) <
                                                    25
                                                ? Colors.red
                                                : (progress.progressPercentage ??
                                                            0) <
                                                        50
                                                    ? Colors.orange
                                                    : (progress.progressPercentage ??
                                                                0) <
                                                            75
                                                        ? Colors.yellow
                                                        : Colors.green,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${((progress.progressPercentage ?? 0)).toInt()}% completed',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Student Information Card with Sorting
                    // Card(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(16.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             const Text(
                    //               'Student Information',
                    //               style: TextStyle(
                    //                 fontSize: 20,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //             // DropdownButton<String>(
                    //             //   value: state.sortBy,
                    //             //   items: const [
                    //             //     DropdownMenuItem(
                    //             //       value: 'name',
                    //             //       child: Text('Sort by Name'),
                    //             //     ),
                    //             //     DropdownMenuItem(
                    //             //       value: 'progress',
                    //             //       child: Text('Sort by Progress'),
                    //             //     ),
                    //             //     DropdownMenuItem(
                    //             //       value: 'class',
                    //             //       child: Text('Sort by Class'),
                    //             //     ),
                    //             //   ],
                    //             //   onChanged: (value) {
                    //             //     if (value != null) {
                    //             //       context.read<TeacherHomeBloc>().add(
                    //             //             SortStudents(value),
                    //             //           );
                    //             //     }
                    //             //   },
                    //             // ),
                    //           ],
                    //         ),
                    //         const SizedBox(height: 16),
                    //         // ListView.builder(
                    //         //   shrinkWrap: true,
                    //         //   physics: const NeverScrollableScrollPhysics(),
                    //         //   // itemCount: state.filteredStudents.length,
                    //         //   itemBuilder: (context, index) {
                    //         //     final student = state.filteredStudents[index];
                    //         //     return Card(
                    //         //       elevation: 2,
                    //         //       margin:
                    //         //           const EdgeInsets.symmetric(vertical: 4),
                    //         //       child: ListTile(
                    //         //         leading: CircleAvatar(
                    //         //           child: Text(student.name[0]),
                    //         //         ),
                    //         //         title: Text(student.name),
                    //         //         subtitle: Text(
                    //         //             student.className ?? 'Unknown Class'),
                    //         //         trailing: IconButton(
                    //         //           icon: const Icon(Icons.arrow_forward),
                    //         //           onPressed: () {
                    //         //             context.read<TeacherHomeBloc>().add(
                    //         //                   ViewStudentDetail(student.id),
                    //         //                 );
                    //         //           },
                    //         //         ),
                    //         //       ),
                    //         //     );
                    //         //   },
                    //         // ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 16),

                    // Assessment and Feedback Card with Filtering
                    // Card(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(16.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             const Text(
                    //               'Assessment & Feedback',
                    //               style: TextStyle(
                    //                 fontSize: 20,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //             // DropdownButton<String>(
                    //             //   value: state.selectedSubject,
                    //             //   items: const [
                    //             //     DropdownMenuItem(
                    //             //       value: 'all',
                    //             //       child: Text('All Subjects'),
                    //             //     ),
                    //             //     DropdownMenuItem(
                    //             //       value: 'math',
                    //             //       child: Text('Mathematics'),
                    //             //     ),
                    //             //     DropdownMenuItem(
                    //             //       value: 'science',
                    //             //       child: Text('Science'),
                    //             //     ),
                    //             //     DropdownMenuItem(
                    //             //       value: 'english',
                    //             //       child: Text('English'),
                    //             //     ),
                    //             //   ],
                    //             //   onChanged: (value) {
                    //             //     if (value != null) {
                    //             //       context.read<TeacherHomeBloc>().add(
                    //             //             FilterAssessments(value),
                    //             //           );
                    //             //     }
                    //             //   },
                    //             // ),
                    //           ],
                    //         ),
                    //         const SizedBox(height: 16),
                    //         // ListView.builder(
                    //         //   shrinkWrap: true,
                    //         //   physics: const NeverScrollableScrollPhysics(),
                    //         //   itemCount: state.filteredAssessments.length,
                    //         //   itemBuilder: (context, index) {
                    //         //     final assessment =
                    //         //         state.filteredAssessments[index];
                    //         //     return Card(
                    //         //       elevation: 2,
                    //         //       margin:
                    //         //           const EdgeInsets.symmetric(vertical: 4),
                    //         //       child: ListTile(
                    //         //         title: Text(assessment.studentName),
                    //         //         subtitle: Text(assessment.taskName),
                    //         //         trailing: ElevatedButton(
                    //         //           onPressed: () {
                    //         //             context.read<TeacherHomeBloc>().add(
                    //         //                   AssessStudent(assessment.id),
                    //         //                 );
                    //         //           },
                    //         //           child: const Text('Assess'),
                    //         //         ),
                    //         //       ),
                    //         //     );
                    //         //   },
                    //         // ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          if (state.isRefreshing)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(),
            ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
