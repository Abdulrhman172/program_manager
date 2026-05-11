import 'package:flutter/material.dart';
import '../model/student_model.dart';

/// Controller for the Students screen.
/// Manages student data, filtering, and search logic.
class StudentsController extends ChangeNotifier {
  final List<Student> _students = [
    Student(
      id: '1',
      name: 'أحمد محمد علي',
      email: 'ahmed@university.edu',
      phone: '+966501234567',
      specialization: 'هندسة البرمجيات',
      advisor: 'أ.د محمد السلام',
      status: 'active',
    ),
    Student(
      id: '2',
      name: 'فاطمة خالد إبراهيم',
      email: 'fatima@university.edu',
      phone: '+966501234568',
      specialization: 'قواعد البيانات',
      advisor: 'أ.د سارة محمود',
      status: 'active',
    ),
    Student(
      id: '3',
      name: 'محمود علي حسن',
      email: 'mahmoud@university.edu',
      phone: '+966501234569',
      specialization: 'الشبكات',
      advisor: 'أ.د علي أحمد',
      status: 'active',
    ),
  ];

  List<Student> _filteredStudents = [];
  final TextEditingController searchController = TextEditingController();

  StudentsController() {
    _filteredStudents = List.from(_students);
    searchController.addListener(_filterStudents);
  }

  List<Student> get students => _students;
  List<Student> get filteredStudents => _filteredStudents;

  int get totalStudents => _filteredStudents.length;
  int get activeStudents =>
      _filteredStudents.where((s) => s.status == 'active').length;
  int get specializations =>
      _filteredStudents.map((s) => s.specialization).toSet().length;

  void _filterStudents() {
    final query = searchController.text.toLowerCase();
    _filteredStudents = _students
        .where((student) =>
            student.name.toLowerCase().contains(query) ||
            student.email.toLowerCase().contains(query) ||
            student.specialization.toLowerCase().contains(query))
        .toList();
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
