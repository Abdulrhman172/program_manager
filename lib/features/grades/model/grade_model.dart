class GradeModel {
  final int? gradeId;
  final int groupId;
  final int idProgram;
  final String groupName;
  double? supervisorGrade;
  double? programManagerGrade;
  double? finalGrade;
  String gradeStatus;
  String? notes;

  GradeModel({
    this.gradeId,
    required this.groupId,
    required this.idProgram,
    required this.groupName,
    this.supervisorGrade,
    this.programManagerGrade,
    this.finalGrade,
    required this.gradeStatus,
    this.notes,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      gradeId: (json['grade_id'] as num?)?.toInt(),
      groupId: (json['id_group'] as num).toInt(),
      idProgram: (json['id_program'] as num).toInt(),
      groupName: json['group_name'] as String? ?? '',
      supervisorGrade: (json['supervisor_grade'] as num?)?.toDouble(),
      programManagerGrade:
          (json['program_manager_grade'] as num?)?.toDouble(),
      finalGrade: (json['final_grade'] as num?)?.toDouble(),
      gradeStatus: json['grade_status'] as String? ?? 'بانتظار المشرف',
      notes: json['notes'] as String?,
    );
  }
}
