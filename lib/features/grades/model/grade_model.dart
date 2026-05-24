class GradeModel {
  final String id;
  final String researchTitle;
  final String supervisorName;
  final String department;
  final double? supervisorGrade; // Max 60
  double? adminGrade; // Max 40

  GradeModel({
    required this.id,
    required this.researchTitle,
    required this.supervisorName,
    required this.department,
    this.supervisorGrade,
    this.adminGrade,
  });

  double get totalGrade => (supervisorGrade ?? 0.0) + (adminGrade ?? 0.0);

  String get status {
    if (supervisorGrade == null) {
      return 'بانتظار المشرف';
    } else if (adminGrade == null) {
      return 'بانتظار المسؤول';
    } else {
      return 'مكتملة';
    }
  }
}
