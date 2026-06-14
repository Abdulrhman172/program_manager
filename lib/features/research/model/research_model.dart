class ResearchFile {
  final String name;
  final String size;
  final String url;

  ResearchFile({required this.name, required this.size, required this.url});
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
    
    // Helper function to safely extract URL from a stage list
    String? extractUrl(dynamic stageData, String key) {
      if (stageData != null && stageData is List && stageData.isNotEmpty) {
        return stageData.first[key] as String?;
      }
      return null;
    }

    final stage1Url = extractUrl(json['first stage'], 'pdf_file');
    final stage2Url = extractUrl(json['stage2_titles_approval'], 'pdf_file');
    final stage3Url = extractUrl(json['third stage(discussion)'], 'pdf_file');
    final stage4Url = extractUrl(json['fourth stage'], 'stage4_pdf');
    final stage5Url = extractUrl(json['fifth_Stage'], 'pdf_file');
    final stage6Url = extractUrl(json['stage 6 (trio discussion)'], 'pdf_file');

    if (stage1Url != null && stage1Url.isNotEmpty) {
      filesList.add(ResearchFile(name: 'ملف المرحلة الأولى', size: 'غير محدد', url: stage1Url));
    }
    if (stage2Url != null && stage2Url.isNotEmpty) {
      filesList.add(ResearchFile(name: 'ملف المرحلة الثانية', size: 'غير محدد', url: stage2Url));
    }
    if (stage3Url != null && stage3Url.isNotEmpty) {
      filesList.add(ResearchFile(name: 'ملف المرحلة الثالثة', size: 'غير محدد', url: stage3Url));
    }
    if (stage4Url != null && stage4Url.isNotEmpty) {
      filesList.add(ResearchFile(name: 'ملف المرحلة الرابعة', size: 'غير محدد', url: stage4Url));
    }
    if (stage5Url != null && stage5Url.isNotEmpty) {
      filesList.add(ResearchFile(name: 'ملف المرحلة الخامسة', size: 'غير محدد', url: stage5Url));
    }
    if (stage6Url != null && stage6Url.isNotEmpty) {
      filesList.add(ResearchFile(name: 'ملف المرحلة السادسة', size: 'غير محدد', url: stage6Url));
    }
    if (finalDocUrl != null && finalDocUrl.isNotEmpty) {
      filesList.add(ResearchFile(name: 'المستند النهائي', size: 'غير محدد', url: finalDocUrl));
    }

    return ResearchModel(
      id: json['group_id']?.toString() ?? '',
      title: json['group_name']?.toString() ?? 'بدون عنوان',
      supervisor: supervisorName ?? 'لم يحدد',
      department: programName,
      currentPhase: stageName,
      lastUpdated: json['created_at'] != null ? json['created_at'].toString().split('T').first : 'غير محدد',
      progress: ((json['group_progress'] as num?)?.toDouble() ?? 0.0) * 100.0,
      files: filesList,
      status: stateName ?? 'غير معروف',
      researchState: stateName ?? 'غير معروف',
      academicYear: academyYearName ?? '2025/2026',
    );
  }
}
