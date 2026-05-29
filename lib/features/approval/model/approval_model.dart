class ApprovalModel {
  final int stage1Id;
  final int groupId;
  final String title;
  final String? description;
  // موافقة مدير البرنامج — هذا ما يتحكم فيه التطبيق
  bool? prgrmMngrApproval;
  // موافقات الأطراف الأخرى (للعرض فقط)
  final bool? sprvsrApproval;
  final bool? headDepApproval;
  String? rejectionReason;
  // بيانات إضافية من الـ View
  final String? sprvsrNote;
  final String? prgrmMngrNote;
  final String? headDepNote;

  ApprovalModel({
    required this.stage1Id,
    required this.groupId,
    required this.title,
    this.description,
    this.prgrmMngrApproval,
    this.sprvsrApproval,
    this.headDepApproval,
    this.rejectionReason,
    this.sprvsrNote,
    this.prgrmMngrNote,
    this.headDepNote,
  });

  // حالة الطلب من منظور مدير البرنامج
  String get status {
    if (prgrmMngrApproval == true) return 'معتمدة';
    if (prgrmMngrApproval == false) return 'مرفوضة';
    return 'في الانتظار';
  }

  factory ApprovalModel.fromJson(Map<String, dynamic> json) {
    return ApprovalModel(
      stage1Id: (json['stage1_id'] as num).toInt(),
      groupId: (json['group_id'] as num).toInt(),
      title: json['research_title'] as String? ?? '',
      description: json['research_description'] as String?,
      prgrmMngrApproval: json['prgrm_mngr_approval'] as bool?,
      sprvsrApproval: json['sprvsr_approval'] as bool?,
      headDepApproval: json['head_dep_approval'] as bool?,
      sprvsrNote: json['sprvsr_note'] as String?,
      prgrmMngrNote: json['prgrm_mngr_note'] as String?,
      headDepNote: json['head_dep_note'] as String?,
    );
  }
}
