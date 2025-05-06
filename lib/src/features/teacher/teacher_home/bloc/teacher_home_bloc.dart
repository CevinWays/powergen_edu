import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/teacher_home_models.dart';
import '../repositories/teacher_home_repository.dart';

// Events
abstract class TeacherHomeEvent {}

class LoadTeacherHomeData extends TeacherHomeEvent {}

class SearchStudents extends TeacherHomeEvent {
  final String query;
  SearchStudents(this.query);
}

class SortStudents extends TeacherHomeEvent {
  final String sortBy;
  SortStudents(this.sortBy);
}

class FilterAssessments extends TeacherHomeEvent {
  final String subject;
  FilterAssessments(this.subject);
}

class ViewStudentDetail extends TeacherHomeEvent {
  final String studentId;
  ViewStudentDetail(this.studentId);
}

class AssessStudent extends TeacherHomeEvent {
  final String assessmentId;
  AssessStudent(this.assessmentId);
}

class Logout extends TeacherHomeEvent {}

// States
abstract class TeacherHomeState {}

class TeacherHomeLoading extends TeacherHomeState {
  final bool isInitial;
  TeacherHomeLoading({this.isInitial = true});
}

class TeacherHomeLoaded extends TeacherHomeState {
  final List<StudentProgress> studentProgress;
  final List<Student> students;
  // final List<PendingAssessment> pendingAssessments;
  final String searchQuery;
  // final String sortBy;
  // final String selectedSubject;
  final bool isRefreshing;

  TeacherHomeLoaded({
    required this.studentProgress,
    required this.students,
    // required this.pendingAssessments,
    this.searchQuery = '',
    String? sortBy,
    String? selectedSubject,
    this.isRefreshing = false,
  });

  TeacherHomeLoaded copyWith({
    List<StudentProgress>? studentProgress,
    List<Student>? students,
    // List<PendingAssessment>? pendingAssessments,
    String? searchQuery,
    String? sortBy,
    String? selectedSubject,
    bool? isRefreshing,
  }) {
    return TeacherHomeLoaded(
      studentProgress: studentProgress ?? this.studentProgress,
      students: students ?? this.students,
      // pendingAssessments: pendingAssessments ?? this.pendingAssessments,
      searchQuery: searchQuery ?? this.searchQuery,
      // sortBy: sortBy ?? this.sortBy,
      // selectedSubject: selectedSubject ?? this.selectedSubject,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  // List<Student> get filteredStudents {
  //   var filtered = List<Student>.from(students);
  //   if (searchQuery.isNotEmpty) {
  //     filtered = filtered
  //         .where((student) =>
  //             student.name.toLowerCase().contains(searchQuery.toLowerCase()))
  //         .toList();
  //   }
  //   switch (sortBy) {
  //     case 'name':
  //       filtered.sort((a, b) => a.name.compareTo(b.name));
  //       break;
  //     case 'class':
  //       filtered.sort((a, b) => (a.className ?? '').compareTo((b.className ?? '')));
  //       break;
  //     case 'progress':
  //       filtered.sort((a, b) {
  //         final aProgress = studentProgress
  //             .firstWhere((p) => p.studentName == a.name,
  //                 orElse: () => StudentProgress(
  //                     id: '', studentName: a.name, progressPercentage: 0))
  //             .progressPercentage;
  //         final bProgress = studentProgress
  //             .firstWhere((p) => p.studentName == b.name,
  //                 orElse: () => StudentProgress(
  //                     id: '', studentName: b.name, progressPercentage: 0))
  //             .progressPercentage;
  //         return (bProgress ?? 0).compareTo(aProgress ?? 0);
  //       });
  //       break;
  //   }
  //   return filtered;
  // }

  // List<PendingAssessment> get filteredAssessments {
  //   if (selectedSubject == 'all') return pendingAssessments;
  //   return pendingAssessments
  //       .where((assessment) => assessment.taskName
  //           .toLowerCase()
  //           .contains(selectedSubject.toLowerCase()))
  //       .toList();
  // }
}

class TeacherHomeError extends TeacherHomeState {
  final String message;
  final bool isRetryable;
  TeacherHomeError(this.message, {this.isRetryable = true});
}

class LogoutSuccess extends TeacherHomeState {}

// Bloc
class TeacherHomeBloc extends Bloc<TeacherHomeEvent, TeacherHomeState> {
  final TeacherHomeRepository _repository;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final PreferencesService _preferencesService;

  TeacherHomeBloc({
    TeacherHomeRepository? repository,
    // PreferencesService? preferencesService,
  })  : _repository = repository ?? TeacherHomeRepository(),
        // _preferencesService = preferencesService ?? PreferencesService(),
        super(TeacherHomeLoading()) {
    on<LoadTeacherHomeData>(_onLoadTeacherHomeData);
    on<SearchStudents>(_onSearchStudents);
    on<SortStudents>(_onSortStudents);
    on<FilterAssessments>(_onFilterAssessments);
    on<ViewStudentDetail>(_onViewStudentDetail);
    on<AssessStudent>(_onAssessStudent);
    on<Logout>(_onLogout);
  }

  Future<void> _onLoadTeacherHomeData(
    LoadTeacherHomeData event,
    Emitter<TeacherHomeState> emit,
  ) async {
    try {
      if (state is! TeacherHomeLoaded) {
        emit(TeacherHomeLoading());
      } else {
        emit((state as TeacherHomeLoaded).copyWith(isRefreshing: true));
      }

      final studentProgress = await _repository.getStudentProgress();
      final students = await _repository.getStudents();
      // final pendingAssessments = await _repository.getPendingAssessments();

      studentProgress.removeWhere((progress) => progress.isTeacher);

      emit(TeacherHomeLoaded(
        studentProgress: studentProgress,
        students: students,
        // pendingAssessments: pendingAssessments,
      ));
    } catch (e) {
      if (state is TeacherHomeLoaded) {
        // Keep existing data but show error snackbar
        emit((state as TeacherHomeLoaded).copyWith(isRefreshing: false));
      } else {
        emit(TeacherHomeError('Failed to load teacher home data: $e'));
      }
    }
  }

  Future<void> _onSearchStudents(
    SearchStudents event,
    Emitter<TeacherHomeState> emit,
  ) async {
    if (state is TeacherHomeLoaded) {
      final currentState = state as TeacherHomeLoaded;
      final result = currentState.studentProgress
          .where((student) =>
              (student.fullName ?? '').toLowerCase().contains(event.query))
          .toList();
      emit(currentState.copyWith(
          searchQuery: event.query, studentProgress: result));
    }
  }

  Future<void> _onSortStudents(
    SortStudents event,
    Emitter<TeacherHomeState> emit,
  ) async {
    if (state is TeacherHomeLoaded) {
      // await _preferencesService.setSortPreference(event.sortBy);
      final currentState = state as TeacherHomeLoaded;
      emit(currentState.copyWith(sortBy: event.sortBy));
    }
  }

  Future<void> _onFilterAssessments(
    FilterAssessments event,
    Emitter<TeacherHomeState> emit,
  ) async {
    if (state is TeacherHomeLoaded) {
      // await _preferencesService.setSubjectFilter(event.subject);
      final currentState = state as TeacherHomeLoaded;
      emit(currentState.copyWith(selectedSubject: event.subject));
    }
  }

  Future<void> _onViewStudentDetail(
    ViewStudentDetail event,
    Emitter<TeacherHomeState> emit,
  ) async {
    try {
      if (state is TeacherHomeLoaded) {
        final currentState = state as TeacherHomeLoaded;
        final student = currentState.students.firstWhere(
          (s) => s.id == event.studentId,
        );

        // await _navigationService.navigateTo(
        //   Routes.studentDetail,
        //   arguments: student,
        // );
      }
    } catch (e) {
      emit(TeacherHomeError('Failed to view student detail: $e',
          isRetryable: false));
    }
  }

  Future<void> _onAssessStudent(
    AssessStudent event,
    Emitter<TeacherHomeState> emit,
  ) async {
    try {
      if (state is TeacherHomeLoaded) {
        final currentState = state as TeacherHomeLoaded;
        // final assessment = currentState.pendingAssessments.firstWhere(
        //   (a) => a.id == event.assessmentId,
        // );

        // await _navigationService.navigateTo(
        //   Routes.assessment,
        //   arguments: assessment,
        // );
      }
    } catch (e) {
      emit(TeacherHomeError('Failed to start assessment: $e',
          isRetryable: false));
    }
  }

  FutureOr<void> _onLogout(event, Emitter<TeacherHomeState> emit) async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Clear SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      emit(LogoutSuccess());
    } catch (e) {
      emit(TeacherHomeError(e.toString()));
    }
  }
}
