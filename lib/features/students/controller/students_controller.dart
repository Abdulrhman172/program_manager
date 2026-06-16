import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';
import '../model/student_model.dart';

class StudentsController extends ChangeNotifier {
  List<StudentModel> _students = [];

  List<String> departments = [];

  List<StudentModel> _filteredStudents = [];
  String _searchQuery = '';
  
  bool _isLoading = false;
  bool _isAddingStudent = false;
  bool _isEditing = false;
  String? _editingStudentId;
  String? _formError;
  String? _selectedDepartment;
  bool _isDisposed = false;
  
  RealtimeChannel? _subscription;

  // Controllers for the new/edit student form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController batchNumberController = TextEditingController();
  final TextEditingController academicYearController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  StudentsController() {
    fetchStudents();
    _setupRealtime();
  }

  void _setupRealtime() {
    _subscription = SupabaseService.client
      .channel('public:student')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'student',
        callback: (payload) {
          fetchStudents();
        },
      )
      .subscribe();
  }

  List<StudentModel> get students => _filteredStudents;
  bool get isLoading => _isLoading;
  bool get isAddingStudent => _isAddingStudent;
  bool get isEditing => _isEditing;
  String? get formError => _formError;
  String? get selectedDepartment => _selectedDepartment;

  Future<void> fetchStudents() async {
    _isLoading = true;
    _formError = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final idProgram = prefs.getInt('id_program');

      if (idProgram != null) {
        // Fetch program name
        final programResponse = await SupabaseService.client
            .from('program')
            .select('program_name')
            .eq('program_id', idProgram)
            .single();
        final programName = programResponse['program_name'] as String;
        
        departments = [programName];
        _selectedDepartment = programName; // Default to this program

        final response = await SupabaseService.client
            .from('student')
            .select('*, program(program_name)')
            .eq('id_program', idProgram);

        _students = (response as List).map((e) => StudentModel.fromJson(e)).toList();
        _filterList();
      }
    } catch (e) {
      _formError = 'حدث خطأ في جلب البيانات: $e';
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void toggleAddStudentForm() {
    if (_isAddingStudent && !_isEditing) {
      // If already adding (not editing), just close it
      _isAddingStudent = false;
      _clearForm();
    } else {
      // Open add form
      _isAddingStudent = true;
      _isEditing = false;
      _editingStudentId = null;
      _clearForm();
    }
    notifyListeners();
  }

  void openEditForm(StudentModel student) {
    _isAddingStudent = true;
    _isEditing = true;
    _editingStudentId = student.id;
    _formError = null;

    nameController.text = student.name;
    idController.text = student.id;
    batchNumberController.text = student.batchNumber;
    academicYearController.text = student.academicYear;
    passwordController.text = ''; // Usually don't show password on edit
    
    // Set department if it exists in the list
    if (departments.contains(student.department)) {
      _selectedDepartment = student.department;
    } else {
      _selectedDepartment = null;
    }

    notifyListeners();
  }

  void setSelectedDepartment(String? dept) {
    _selectedDepartment = dept;
    notifyListeners();
  }

  void cancelAddStudent() {
    _isAddingStudent = false;
    _isEditing = false;
    _editingStudentId = null;
    _clearForm();
    notifyListeners();
  }

  Future<void> saveStudent() async {
    _formError = null;

    // Validation
    if (nameController.text.trim().isEmpty ||
        idController.text.trim().isEmpty ||
        batchNumberController.text.trim().isEmpty ||
        academicYearController.text.trim().isEmpty ||
        _selectedDepartment == null) {
      _formError = 'يرجى تعبئة جميع الحقول وإختيار القسم';
      notifyListeners();
      return;
    }

    // Require password only when creating new student
    if (!_isEditing && passwordController.text.trim().isEmpty) {
      _formError = 'يرجى إدخال كلمة المرور';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final idProgram = prefs.getInt('id_program');

      if (idProgram == null) {
        _formError = 'لم يتم تحديد البرنامج';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final studentData = {
        'stud_name': nameController.text.trim(),
        'stud_college_num': int.tryParse(idController.text.trim()) ?? 0,
        'stud_cohort_num': int.tryParse(batchNumberController.text.trim()) ?? 0,
        'id_academy_year': int.tryParse(academicYearController.text.trim()) ?? 1,
        'id_program': idProgram,
      };

      if (passwordController.text.isNotEmpty) {
        studentData['stud_pass'] = passwordController.text.trim();
      }

      if (_isEditing && _editingStudentId != null) {
        // Update existing
        await SupabaseService.client
            .from('student')
            .update(studentData)
            .eq('stud_college_num', int.tryParse(_editingStudentId!) ?? 0)
            .eq('id_program', idProgram);
      } else {
        // Add new
        await SupabaseService.client.from('student').insert(studentData);
      }

      await fetchStudents();
      _isAddingStudent = false;
      _isEditing = false;
      _editingStudentId = null;
      _clearForm();
    } catch (e) {
      _formError = 'حدث خطأ أثناء الحفظ: $e';
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void search(String query) {
    _searchQuery = query;
    _filterList();
    notifyListeners();
  }

  void _filterList() {
    if (_searchQuery.isEmpty) {
      _filteredStudents = List.from(_students);
    } else {
      _filteredStudents = _students
          .where((student) =>
              student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              student.id.contains(_searchQuery))
          .toList();
    }
  }

  Future<void> deleteStudent(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final idProgram = prefs.getInt('id_program');

      if (idProgram != null) {
        await SupabaseService.client
            .from('student')
            .delete()
            .eq('stud_college_num', int.tryParse(id) ?? 0)
            .eq('id_program', idProgram);
        await fetchStudents();
      }
    } catch (e) {
      if (!_isDisposed) {
        _formError = 'حدث خطأ أثناء الحذف: $e';
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void _clearForm() {
    nameController.clear();
    idController.clear();
    batchNumberController.clear();
    academicYearController.clear();
    passwordController.clear();
    _selectedDepartment = null;
    _formError = null;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _subscription?.unsubscribe();
    nameController.dispose();
    idController.dispose();
    batchNumberController.dispose();
    academicYearController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
