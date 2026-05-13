import 'package:flutter/material.dart';
import '../model/research_model.dart';

class ResearchController extends ChangeNotifier {
  final List<ResearchModel> _researches = [
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
    ),
  ];

  List<ResearchModel> _filteredResearches = [];
  String _searchQuery = '';

  ResearchController() {
    _filteredResearches = _researches;
  }

  List<ResearchModel> get researches => _filteredResearches;

  int get totalCount => _researches.length;
  int get advancedPhaseCount => _researches.where((r) => r.status == 'المرحلة المتقدمة').length;
  int get inProgressCount => _researches.where((r) => r.status == 'قيد التنفيذ').length;
  int get inBeginningCount => _researches.where((r) => r.status == 'في البداية').length;

  void search(String query) {
    _searchQuery = query;
    _filterList();
    notifyListeners();
  }

  void _filterList() {
    if (_searchQuery.isEmpty) {
      _filteredResearches = List.from(_researches);
    } else {
      _filteredResearches = _researches
          .where((r) =>
              r.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              r.supervisor.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void downloadAllFiles(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري تحميل جميع الملفات...', textAlign: TextAlign.right),
        backgroundColor: Color(0xFF2563EB), // Blue
        duration: Duration(seconds: 2),
      ),
    );
  }

  void downloadSingleFile(BuildContext context, String fileName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تحميل $fileName...', textAlign: TextAlign.right),
        backgroundColor: const Color(0xFF2563EB), // Blue
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
