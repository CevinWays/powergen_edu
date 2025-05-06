import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/teacher_home_models.dart';

class TeacherHomeRepository {
  final FirebaseFirestore _firestore;

  TeacherHomeRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<StudentProgress>> getStudentProgress() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return StudentProgress(
          id: data['uid'] as String,
          nis: data['nis'] as String,
          fullName: data['fullName'] as String?,
          studentName: data['username'] as String,
          isTeacher: data['isTeacher'] as bool,
          progressPercentage:
              (data['total_progress'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch student progress: $e');
    }
  }

  Future<List<Student>> getStudents() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Student(
          id: data['uid'] as String,
          nis: data['nis'] as String,
          fullName: data['fullName'] as String?,
          name: data['username'] as String,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  Future<List<PendingAssessment>> getPendingAssessments() async {
    try {
      final snapshot = await _firestore
          .collection('assessments')
          .where('status', isEqualTo: 'pending')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return PendingAssessment(
          id: doc.id,
          studentName: data['studentName'] as String,
          taskName: data['taskName'] as String,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch pending assessments: $e');
    }
  }

  Future<void> submitAssessment({
    required String assessmentId,
    required int score,
    required String feedback,
  }) async {
    try {
      await _firestore.collection('assessments').doc(assessmentId).update({
        'status': 'completed',
        'score': score,
        'feedback': feedback,
        'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to submit assessment: $e');
    }
  }
}
