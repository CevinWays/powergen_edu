class StudentProgress {
  final String id;
  final String studentName;
  final String nis;
  final String? fullName;
  final double? progressPercentage;

  StudentProgress({
    required this.id,
    required this.studentName,
    required this.nis,
    this.fullName,
    this.progressPercentage,
  });
}

class Student {
  final String id;
  final String name;
  final String? fullName;
  final String? nis;
  final String? className;

  Student({
    required this.id,
    required this.name,
    this.className,
    this.fullName,
    this.nis,

  });
}

class PendingAssessment {
  final String id;
  final String studentName;
  final String taskName;

  PendingAssessment({
    required this.id,
    required this.studentName,
    required this.taskName,
  });
}
