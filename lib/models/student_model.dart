class Student {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String specialization;
  final String advisor;
  final String status; // active, inactive

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.advisor,
    required this.status,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      specialization: json['specialization'] as String,
      advisor: json['advisor'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'specialization': specialization,
      'advisor': advisor,
      'status': status,
    };
  }
}
