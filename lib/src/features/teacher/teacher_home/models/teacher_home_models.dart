class StudentProgress {
  final String id;
  final String studentName;
  final String nis;
  final String? fullName;
  final double? progressPercentage;
  final bool isTeacher;
  final double? pointPretest;
  final double? pointPostTestModul1;
  final double? pointPostTestModul2;
  final double? pointPostTestModul3;
  final double? pointPostTestModul4;

  StudentProgress({
    required this.id,
    required this.studentName,
    required this.nis,
    this.fullName,
    this.progressPercentage,
    this.isTeacher = false,
    this.pointPretest,
    this.pointPostTestModul1,
    this.pointPostTestModul2,
    this.pointPostTestModul3,
    this.pointPostTestModul4,
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
