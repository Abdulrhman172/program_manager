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
      id: json['id'] as String,
      name: json['name'] as String,
      department: json['department'] as String,
      batchNumber: json['batchNumber'] as String,
      academicYear: json['academicYear'] as String,
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
