class ResearchProject {
  final String id;
  final String title;
  final String studentName;
  final String advisor;
  final String submissionDate;
  final String stage;
  final String status; // pending, approved, rejected

  ResearchProject({
    required this.id,
    required this.title,
    required this.studentName,
    required this.advisor,
    required this.submissionDate,
    required this.stage,
    required this.status,
  });

  factory ResearchProject.fromJson(Map<String, dynamic> json) {
    return ResearchProject(
      id: json['id'] as String,
      title: json['title'] as String,
      studentName: json['studentName'] as String,
      advisor: json['advisor'] as String,
      submissionDate: json['submissionDate'] as String,
      stage: json['stage'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'studentName': studentName,
      'advisor': advisor,
      'submissionDate': submissionDate,
      'stage': stage,
      'status': status,
    };
  }
}
