class TeamMemberModel {
  final String id;
  final String name;
  final String role; // 'قائد الفريق' or 'عضو'

  TeamMemberModel({
    required this.id,
    required this.name,
    required this.role,
  });
}

class TeamModel {
  final String id;
  final String projectTitle;
  final String department;
  final String supervisor;
  final List<TeamMemberModel> members;

  TeamModel({
    required this.id,
    required this.projectTitle,
    required this.department,
    required this.supervisor,
    required this.members,
  });
}
