class SupervisorModel {
  final String id;
  final String name;
  final String department;
  final String email;
  final int researchCount;
  bool isActive;

  SupervisorModel({
    required this.id,
    required this.name,
    required this.department,
    required this.email,
    required this.researchCount,
    required this.isActive,
  });

  factory SupervisorModel.fromJson(Map<String, dynamic> json) {
    return SupervisorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      department: json['department'] as String,
      email: json['email'] as String,
      researchCount: json['researchCount'] as int,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'email': email,
      'researchCount': researchCount,
      'isActive': isActive,
    };
  }
}
