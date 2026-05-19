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
}
