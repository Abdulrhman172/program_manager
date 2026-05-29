import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/supabase_service.dart';
import '../model/research_model.dart';

class ResearchController extends ChangeNotifier {
  List<ResearchModel> _researches = [];
  List<ResearchModel> _filteredResearches = [];
  String _searchQuery = '';
  String _stateFilter = 'الكل'; // 'الكل', 'نشط', 'متوقف', 'مؤرشف'
  
  bool _isLoading = false;
  String? _errorMessage;

  // For archived drill-down
  String? _selectedArchiveYear; // null = show year list, String = show that year's researches

  ResearchController() {
    fetchResearches();
  }

  List<ResearchModel> get researches => _filteredResearches;
  String get stateFilter => _stateFilter;
  String? get selectedArchiveYear => _selectedArchiveYear;
  bool get isInArchivedMode => _stateFilter == 'مؤرشف';
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Stats (always from active researches only)
  List<ResearchModel> get _activeResearches => _researches.where((r) => r.researchState != 'مؤرشف').toList();
  int get totalCount => _activeResearches.length;
  int get advancedPhaseCount => _activeResearches.where((r) => r.status == 'المرحلة المتقدمة' || r.progress >= 70).length;
  int get inProgressCount => _activeResearches.where((r) => r.status == 'قيد التنفيذ' || (r.progress < 70 && r.progress > 0)).length;
  int get inBeginningCount => _activeResearches.where((r) => r.status == 'في البداية' || r.progress == 0).length;

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

  Future<void> fetchResearches() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final idProgram = prefs.getInt('id_program');

      if (idProgram == null) {
        _errorMessage = 'لم يتم تحديد البرنامج';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await SupabaseService.client
          .from('groups')
          .select('*, supervisor(sprvsr_name), GroupState(states_name), AcademyYear(acye_years)')
          .eq('id_program', idProgram);

      _researches = (response as List).map((e) => ResearchModel.fromJson(e)).toList();
      _applyFilter();
      
    } catch (e) {
      _errorMessage = 'حدث خطأ في جلب البيانات: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
