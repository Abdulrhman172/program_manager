class StudentModel {
  final String id;
  final String name;
  final String department;
  final String username;

  StudentModel({
    required this.id,
    required this.name,
    required this.department,
    required this.username,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      department: json['department'] as String,
      username: json['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'username': username,
    };
  }
}
