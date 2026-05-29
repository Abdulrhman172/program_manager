class SupervisorModel {
  final int id;
  final String name;
  final String email;
  final String? phoneNum;
  final int researchCount;
  bool isActive;

  SupervisorModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNum,
    required this.researchCount,
    required this.isActive,
  });

  factory SupervisorModel.fromJson(Map<String, dynamic> json) {
    return SupervisorModel(
      id: (json['sprvsr_id'] as num).toInt(),
      name: json['sprvsr_name'] as String? ?? '',
      email: json['sprvsr_email'] as String? ?? '',
      phoneNum: json['sprvsr_phone_num']?.toString(),
      researchCount: (json['sprvsr_project_num'] as num?)?.toInt() ?? 0,
      isActive: json['sprvsr_isactive'] as bool? ?? true,
    );
  }
}
