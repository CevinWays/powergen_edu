class StudentProgress {
  final String id;
  final String studentName;
  final double? progressPercentage;

  StudentProgress({
    required this.id,
    required this.studentName,
    this.progressPercentage,
  });
}

class Student {
  final String id;
  final String name;
  final String? className;

  Student({
    required this.id,
    required this.name,
    this.className,
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
