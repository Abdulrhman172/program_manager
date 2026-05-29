class StudentModel {
  final String id;
  final String name;
  final String department;
  final String batchNumber;
  final String academicYear;

  StudentModel({
    required this.id,
    required this.name,
    required this.department,
    required this.batchNumber,
    required this.academicYear,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['stud_college_num']?.toString() ?? '',
      name: json['stud_name']?.toString() ?? '',
      department: 'تقنية معلومات', // سيتم تحديثه لاحقاً إذا لزم الأمر
      batchNumber: json['stud_cohort_num']?.toString() ?? '',
      academicYear: json['id_academy_year']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'batchNumber': batchNumber,
      'academicYear': academicYear,
    };
  }
}
