import 'package:flutter/material.dart';
import '../model/research_model.dart';

class ResearchController extends ChangeNotifier {
  final List<ResearchModel> _researches = [
    // --- Active researches (2025/2026) ---
    ResearchModel(
      id: '1',
      title: 'نظام إدارة المكتبة الإلكترونية',
      supervisor: 'د. محمد أحمد علي',
      department: 'إدارة أعمال عربي',
      currentPhase: 'المرحلة الثانية',
      lastUpdated: '28-03-2026',
      progress: 65.0,
      files: [
        ResearchFile(name: 'المرحلة الأولى.pdf', size: '2.5 MB'),
        ResearchFile(name: 'المرحلة الثانية.pdf', size: '3.8 MB'),
      ],
      status: 'قيد التنفيذ',
      researchState: 'نشط',
      academicYear: '2025/2026',
    ),
    ResearchModel(
      id: '2',
      title: 'تطبيق متابعة الحضور والغياب',
      supervisor: 'د. فاطمة سالم حسن',
      department: 'إدارة أعمال انجليزي',
      currentPhase: 'المرحلة الثانية',
      lastUpdated: '30-03-2026',
      progress: 70.0,
      files: [
        ResearchFile(name: 'المرحلة الأولى.pdf', size: '2.1 MB'),
        ResearchFile(name: 'المرحلة الثانية.pdf', size: '4.2 MB'),
      ],
      status: 'قيد التنفيذ',
      researchState: 'نشط',
      academicYear: '2025/2026',
    ),
    ResearchModel(
      id: '3',
      title: 'منصة التعليم الإلكتروني التفاعلية',
      supervisor: 'د. نورة عبدالله سعيد',
      department: 'الترجمة',
      currentPhase: 'المرحلة الأولى',
      lastUpdated: '25-03-2026',
      progress: 30.0,
      files: [
        ResearchFile(name: 'مقترح البحث.pdf', size: '1.2 MB'),
      ],
      status: 'في البداية',
      researchState: 'نشط',
      academicYear: '2025/2026',
    ),
    ResearchModel(
      id: '4',
      title: 'نظام إدارة المطاعم الذكي',
      supervisor: 'د. أحمد حسين عمر',
      department: 'تسويق رقمي',
      currentPhase: 'المرحلة الأولى',
      lastUpdated: '26-03-2026',
      progress: 25.0,
      files: [
        ResearchFile(name: 'ملخص الفكرة.pdf', size: '0.8 MB'),
      ],
      status: 'في البداية',
      researchState: 'متوقف',
      academicYear: '2025/2026',
    ),
    ResearchModel(
      id: '5',
      title: 'تحليل البيانات الضخمة للشركات',
      supervisor: 'د. محمد أحمد علي',
      department: 'إدارة أعمال دولية',
      currentPhase: 'المرحلة الثالثة',
      lastUpdated: '02-04-2026',
      progress: 90.0,
      files: [
        ResearchFile(name: 'المرحلة الأولى.pdf', size: '2.0 MB'),
        ResearchFile(name: 'المرحلة الثانية.pdf', size: '5.1 MB'),
        ResearchFile(name: 'المسودة النهائية.pdf', size: '12.4 MB'),
      ],
      status: 'المرحلة المتقدمة',
      researchState: 'نشط',
      academicYear: '2025/2026',
    ),
    ResearchModel(
      id: '6',
      title: 'تطبيق التوصيل السريع',
      supervisor: 'د. خالد يحيى محمود',
      department: 'إدارة أعمال عربي',
      currentPhase: 'المرحلة الثانية',
      lastUpdated: '29-03-2026',
      progress: 55.0,
      files: [
        ResearchFile(name: 'خطة العمل.pdf', size: '1.5 MB'),
        ResearchFile(name: 'تصميم الواجهات.pdf', size: '8.3 MB'),
      ],
      status: 'قيد التنفيذ',
      researchState: 'متوقف',
      academicYear: '2025/2026',
    ),

    // --- Archived: 2024/2025 ---
    ResearchModel(
      id: 'a1',
      title: 'نظام الموارد البشرية الإلكتروني',
      supervisor: 'د. سامي عبدالله',
      department: 'إدارة أعمال عربي',
      currentPhase: 'مكتمل',
      lastUpdated: '15-06-2025',
      progress: 100.0,
      files: [
        ResearchFile(name: 'المرحلة الأولى.pdf', size: '2.0 MB'),
        ResearchFile(name: 'التقرير النهائي.pdf', size: '8.0 MB'),
      ],
      status: 'مكتمل',
      researchState: 'مؤرشف',
      academicYear: '2024/2025',
    ),
    ResearchModel(
      id: 'a2',
      title: 'تطبيق الصحة الرقمية',
      supervisor: 'د. منى سعد',
      department: 'المحاسبة',
      currentPhase: 'مكتمل',
      lastUpdated: '20-06-2025',
      progress: 100.0,
      files: [
        ResearchFile(name: 'الدراسة الجدوى.pdf', size: '3.1 MB'),
        ResearchFile(name: 'التقرير النهائي.pdf', size: '10.5 MB'),
      ],
      status: 'مكتمل',
      researchState: 'مؤرشف',
      academicYear: '2024/2025',
    ),

    // --- Archived: 2023/2024 ---
    ResearchModel(
      id: 'b1',
      title: 'منصة التجارة الإلكترونية المحلية',
      supervisor: 'د. أحمد سالم',
      department: 'تسويق رقمي',
      currentPhase: 'مكتمل',
      lastUpdated: '10-06-2024',
      progress: 100.0,
      files: [
        ResearchFile(name: 'المرحلة الأولى.pdf', size: '1.8 MB'),
        ResearchFile(name: 'التقرير النهائي.pdf', size: '7.2 MB'),
      ],
      status: 'مكتمل',
      researchState: 'مؤرشف',
      academicYear: '2023/2024',
    ),
    ResearchModel(
      id: 'b2',
      title: 'نظام إدارة المستودعات',
      supervisor: 'د. خالد يحيى محمود',
      department: 'إدارة أعمال دولية',
      currentPhase: 'مكتمل',
      lastUpdated: '12-06-2024',
      progress: 100.0,
      files: [
        ResearchFile(name: 'خطة المشروع.pdf', size: '2.4 MB'),
        ResearchFile(name: 'التقرير النهائي.pdf', size: '9.8 MB'),
      ],
      status: 'مكتمل',
      researchState: 'مؤرشف',
      academicYear: '2023/2024',
    ),
  ];

  List<ResearchModel> _filteredResearches = [];
  String _searchQuery = '';
  String _stateFilter = 'الكل'; // 'الكل', 'نشط', 'متوقف', 'مؤرشف'

  // For archived drill-down
  String? _selectedArchiveYear; // null = show year list, String = show that year's researches

  ResearchController() {
    _applyFilter();
  }

  List<ResearchModel> get researches => _filteredResearches;
  String get stateFilter => _stateFilter;
  String? get selectedArchiveYear => _selectedArchiveYear;
  bool get isInArchivedMode => _stateFilter == 'مؤرشف';

  // Stats (always from active researches only)
  List<ResearchModel> get _activeResearches => _researches.where((r) => r.researchState != 'مؤرشف').toList();
  int get totalCount => _activeResearches.length;
  int get advancedPhaseCount => _activeResearches.where((r) => r.status == 'المرحلة المتقدمة').length;
  int get inProgressCount => _activeResearches.where((r) => r.status == 'قيد التنفيذ').length;
  int get inBeginningCount => _activeResearches.where((r) => r.status == 'في البداية').length;

  // Archive academic years available
  List<String> get archiveYears {
    final years = _researches
        .where((r) => r.researchState == 'مؤرشف')
        .map((r) => r.academicYear)
        .toSet()
        .toList();
    years.sort((a, b) => b.compareTo(a)); // newest first
    return years;
  }

  void setFilter(String filter) {
    _stateFilter = filter;
    _selectedArchiveYear = null; // reset year selection when switching filters
    _applyFilter();
    notifyListeners();
  }

  void selectArchiveYear(String year) {
    _selectedArchiveYear = year;
    _applyFilter();
    notifyListeners();
  }

  void backToArchiveYears() {
    _selectedArchiveYear = null;
    _filteredResearches = [];
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    List<ResearchModel> temp;

    if (_stateFilter == 'مؤرشف') {
      if (_selectedArchiveYear != null) {
        temp = _researches.where((r) => r.researchState == 'مؤرشف' && r.academicYear == _selectedArchiveYear).toList();
      } else {
        _filteredResearches = [];
        return;
      }
    } else if (_stateFilter == 'الكل') {
      // "All" excludes archived
      temp = _researches.where((r) => r.researchState != 'مؤرشف').toList();
    } else {
      final stateMap = {'نشط': 'نشط', 'متوقف': 'متوقف'};
      final mapped = stateMap[_stateFilter] ?? _stateFilter;
      temp = _researches.where((r) => r.researchState == mapped).toList();
    }

    if (_searchQuery.isNotEmpty) {
      temp = temp
          .where((r) =>
              r.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              r.supervisor.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    _filteredResearches = temp;
  }

  void downloadAllFiles(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري تحميل جميع الملفات...', textAlign: TextAlign.right),
        backgroundColor: Color(0xFF2563EB),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void downloadSingleFile(BuildContext context, String fileName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تحميل $fileName...', textAlign: TextAlign.right),
        backgroundColor: const Color(0xFF2563EB),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
