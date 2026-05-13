class ApprovalModel {
  final String id;
  final String title;
  final String description;
  final List<String> members;
  final String supervisor;
  final String submissionDate;
  String status; // 'في الانتظار', 'معتمدة', 'مرفوضة'

  ApprovalModel({
    required this.id,
    required this.title,
    required this.description,
    required this.members,
    required this.supervisor,
    required this.submissionDate,
    required this.status,
  });
}
