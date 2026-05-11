import 'package:flutter/material.dart';
import '../model/research_model.dart';

/// Controller for the Approval screen.
/// Manages research projects approval/rejection logic.
class ApprovalController extends ChangeNotifier {
  List<ResearchProject> _projects = [
    ResearchProject(
      id: '1',
      title: 'نظام إدارة المكتبات الذكية',
      studentName: 'أحمد محمد علي',
      advisor: 'أ.د محمد السلام',
      submissionDate: '15/03/2026',
      stage: 'المرحلة الأولى',
      status: 'pending',
    ),
    ResearchProject(
      id: '2',
      title: 'تطبيق الذكاء الاصطناعي في التعليم',
      studentName: 'فاطمة خالد إبراهيم',
      advisor: 'أ.د سارة محمود',
      submissionDate: '10/03/2026',
      stage: 'المرحلة الثانية',
      status: 'pending',
    ),
    ResearchProject(
      id: '3',
      title: 'نظام أمان الشبكات المتقدم',
      studentName: 'محمود علي حسن',
      advisor: 'أ.د علي أحمد',
      submissionDate: '05/03/2026',
      stage: 'المرحلة الأولى',
      status: 'approved',
    ),
  ];

  List<ResearchProject> get projects => _projects;

  List<ResearchProject> get pendingProjects =>
      _projects.where((p) => p.status == 'pending').toList();

  List<ResearchProject> get approvedProjects =>
      _projects.where((p) => p.status == 'approved').toList();

  List<ResearchProject> get rejectedProjects =>
      _projects.where((p) => p.status == 'rejected').toList();

  void approveProject(String id) {
    _projects = _projects.map((p) {
      if (p.id == id) {
        return ResearchProject(
          id: p.id,
          title: p.title,
          studentName: p.studentName,
          advisor: p.advisor,
          submissionDate: p.submissionDate,
          stage: p.stage,
          status: 'approved',
        );
      }
      return p;
    }).toList();
    notifyListeners();
  }

  void rejectProject(String id) {
    _projects = _projects.map((p) {
      if (p.id == id) {
        return ResearchProject(
          id: p.id,
          title: p.title,
          studentName: p.studentName,
          advisor: p.advisor,
          submissionDate: p.submissionDate,
          stage: p.stage,
          status: 'rejected',
        );
      }
      return p;
    }).toList();
    notifyListeners();
  }
}
