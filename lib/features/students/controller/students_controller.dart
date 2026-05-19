import 'package:flutter/material.dart';
import '../model/student_model.dart';

class StudentsController extends ChangeNotifier {
  // Mock Data
  final List<StudentModel> _students = [
    StudentModel(id: '2021001', name: 'عبدالله محمد سعيد', department: 'إدارة أعمال عربي', batchNumber: 'الدفعة 15', academicYear: '2025/2026'),
    StudentModel(id: '2021002', name: 'فاطمة أحمد علي', department: 'إدارة أعمال إنجليزي', batchNumber: 'الدفعة 15', academicYear: '2025/2026'),
    StudentModel(id: '2021003', name: 'خالد حسن محمود', department: 'إدارة أعمال دولية', batchNumber: 'الدفعة 14', academicYear: '2024/2025'),
    StudentModel(id: '2021004', name: 'نور سالم عبدالله', department: 'محاسبة', batchNumber: 'الدفعة 16', academicYear: '2026/2027'),
    StudentModel(id: '2021005', name: 'أحمد يحيى حسين', department: 'ترجمة', batchNumber: 'الدفعة 15', academicYear: '2025/2026'),
  ];

  final List<String> departments = [
    'إدارة أعمال عربي',
    'إدارة أعمال انجليزي',
    'إدارة أعمال دولية',
    'تسويق رقمي',
    'المحاسبة',
    'الترجمة',
  ];

  List<StudentModel> _filteredStudents = [];
  String _searchQuery = '';
  
  bool _isAddingStudent = false;
  bool _isEditing = false;
  String? _editingStudentId;
  String? _formError;
  String? _selectedDepartment;

  // Controllers for the new/edit student form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController batchNumberController = TextEditingController();
  final TextEditingController academicYearController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  StudentsController() {
    _filteredStudents = _students;
  }

  List<StudentModel> get students => _filteredStudents;
  bool get isAddingStudent => _isAddingStudent;
  bool get isEditing => _isEditing;
  String? get formError => _formError;
  String? get selectedDepartment => _selectedDepartment;

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

  void saveStudent() {
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

    final student = StudentModel(
      id: idController.text.trim(),
      name: nameController.text.trim(),
      department: _selectedDepartment!,
      batchNumber: batchNumberController.text.trim(),
      academicYear: academicYearController.text.trim(),
    );

    if (_isEditing && _editingStudentId != null) {
      // Update existing
      final index = _students.indexWhere((s) => s.id == _editingStudentId);
      if (index != -1) {
        _students[index] = student;
      }
    } else {
      // Check if ID already exists
      if (_students.any((s) => s.id == student.id)) {
        _formError = 'الرقم الجامعي مسجل مسبقاً';
        notifyListeners();
        return;
      }
      // Add new
      _students.insert(0, student);
    }

    _filterList();
    _isAddingStudent = false;
    _isEditing = false;
    _editingStudentId = null;
    _clearForm();
    notifyListeners();
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

  void deleteStudent(String id) {
    _students.removeWhere((s) => s.id == id);
    _filterList();
    notifyListeners();
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
    nameController.dispose();
    idController.dispose();
    batchNumberController.dispose();
    academicYearController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
