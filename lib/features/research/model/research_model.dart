class ResearchFile {
  final String name;
  final String size;

  ResearchFile({required this.name, required this.size});
}

class ResearchModel {
  final String id;
  final String title;
  final String supervisor;
  final String department;
  final String currentPhase;
  final String lastUpdated;
  final double progress; // percentage e.g. 65 for 65%
  final List<ResearchFile> files;
  final String status;       // label shown in stats cards
  final String researchState; // 'نشط', 'متوقف', 'مؤرشف'
  final String academicYear;  // e.g. '2025/2026'

  ResearchModel({
    required this.id,
    required this.title,
    required this.supervisor,
    required this.department,
    required this.currentPhase,
    required this.lastUpdated,
    required this.progress,
    required this.files,
    required this.status,
    required this.researchState,
    required this.academicYear,
  });

  factory ResearchModel.fromJson(Map<String, dynamic> json) {
    // Extract related data if joined, otherwise fallback
    final supervisorName = json['supervisor'] != null ? json['supervisor']['sprvsr_name'] : 'لم يحدد';
    final stateName = json['GroupState'] != null ? json['GroupState']['states_name'] : 'غير معروف';
    final academyYearName = json['AcademyYear'] != null ? json['AcademyYear']['acye_year'] : '2025/2026';
    final programName = json['program'] != null ? json['program']['program_name'] : 'برنامج غير محدد';
    final stageName = json['stages'] != null ? json['stages']['stage_name'] : 'المرحلة الأولى';

    final finalDocUrl = json['final_document'] as String?;
    List<ResearchFile> filesList = [];
    if (finalDocUrl != null && finalDocUrl.isNotEmpty) {
      filesList.add(ResearchFile(name: 'المستند النهائي', size: 'Unknown'));
    }

    return ResearchModel(
      id: json['group_id']?.toString() ?? '',
      title: json['group_name']?.toString() ?? 'بدون عنوان',
      supervisor: supervisorName ?? 'لم يحدد',
      department: programName,
      currentPhase: stageName,
      lastUpdated: json['created_at'] != null ? json['created_at'].toString().split('T').first : 'غير محدد',
      progress: (json['group_progress'] as num?)?.toDouble() ?? 0.0,
      files: filesList,
      status: stateName ?? 'غير معروف',
      researchState: stateName ?? 'غير معروف',
      academicYear: academyYearName ?? '2025/2026',
    );
  }
}
