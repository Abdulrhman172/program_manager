class TeamMemberModel {
  final int id;
  final String name;
  final String role; // 'قائد الفريق' or 'عضو'

  TeamMemberModel({
    required this.id,
    required this.name,
    required this.role,
  });
}

class TeamModel {
  final int groupId;
  final String groupName;
  final String programName;
  final String? supervisorName;
  final String? supervisorEmail;
  final String? groupState;
  final double groupProgress;
  final int currentStage;
  final bool archived;
  final bool isActive;
  final List<TeamMemberModel> members;

  TeamModel({
    required this.groupId,
    required this.groupName,
    required this.programName,
    this.supervisorName,
    this.supervisorEmail,
    this.groupState,
    required this.groupProgress,
    required this.currentStage,
    required this.archived,
    required this.isActive,
    required this.members,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      groupId: (json['group_id'] as num).toInt(),
      groupName: json['group_name'] as String? ?? '',
      programName: json['program_name'] as String? ?? '',
      supervisorName: json['sprvsr_name'] as String?,
      supervisorEmail: json['sprvsr_email'] as String?,
      groupState: json['group_state'] as String?,
      groupProgress: (json['group_progress'] as num?)?.toDouble() ?? 0.0,
      currentStage: (json['current_stage'] as num?)?.toInt() ?? 1,
      archived: json['archived'] as bool? ?? false,
      isActive: json['group_isactive'] as bool? ?? true,
      members: [],
    );
  }
}
