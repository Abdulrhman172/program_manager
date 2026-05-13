import 'package:flutter/material.dart';
import '../model/approval_model.dart';

class ApprovalController extends ChangeNotifier {
  final List<ApprovalModel> _approvals = [
    ApprovalModel(
      id: '1',
      title: 'نظام إدارة المكتبة الإلكترونية',
      description: 'نظام شامل لإدارة المكتبات الجامعية إلكترونياً',
      members: ['عبدالله محمد', 'خالد أحمد', 'فاطمة سالم'],
      supervisor: 'د. محمد أحمد علي',
      submissionDate: '15-02-2026',
      status: 'في الانتظار',
    ),
    ApprovalModel(
      id: '2',
      title: 'منصة التعليم التفاعلية',
      description: 'منصة ذكية تهدف إلى تحسين جودة التعليم عن بعد باستخدام تقنيات الذكاء الاصطناعي',
      members: ['نور عبدالله', 'سعيد علي'],
      supervisor: 'د. فاطمة سالم حسن',
      submissionDate: '16-02-2026',
      status: 'في الانتظار',
    ),
    ApprovalModel(
      id: '3',
      title: 'تطبيق متابعة الحضور والغياب',
      description: 'تطبيق جوال يعتمد على تحديد الموقع لتسجيل حضور الطلاب',
      members: ['أحمد حسين', 'عمر خالد', 'يوسف أحمد'],
      supervisor: 'د. خالد يحيى محمود',
      submissionDate: '14-02-2026',
      status: 'في الانتظار',
    ),
    ApprovalModel(
      id: '4',
      title: 'نظام تحليل البيانات للشركات',
      description: 'نظام إحصائي لتحليل البيانات الكبيرة للشركات التجارية',
      members: ['سارة محمد', 'علياء حسين'],
      supervisor: 'د. محمد أحمد علي',
      submissionDate: '10-02-2026',
      status: 'معتمدة',
    ),
    ApprovalModel(
      id: '5',
      title: 'تطبيق طلب الطعام الجامعي',
      description: 'تطبيق لتسهيل طلب الوجبات من كافتيريا الجامعة',
      members: ['خالد سعد', 'حسن محمود'],
      supervisor: 'د. نورة عبدالله',
      submissionDate: '11-02-2026',
      status: 'مرفوضة',
    ),
  ];

  List<ApprovalModel> _filteredApprovals = [];
  String _searchQuery = '';

  ApprovalController() {
    _filteredApprovals = _approvals;
  }

  List<ApprovalModel> get approvals => _filteredApprovals;

  int get pendingCount => _approvals.where((a) => a.status == 'في الانتظار').length;
  int get approvedCount => _approvals.where((a) => a.status == 'معتمدة').length;
  int get rejectedCount => _approvals.where((a) => a.status == 'مرفوضة').length;

  void changeStatus(String id, String newStatus) {
    final index = _approvals.indexWhere((a) => a.id == id);
    if (index != -1) {
      _approvals[index].status = newStatus;
      _filterList();
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    _filterList();
    notifyListeners();
  }

  void _filterList() {
    if (_searchQuery.isEmpty) {
      _filteredApprovals = List.from(_approvals);
    } else {
      _filteredApprovals = _approvals
          .where((approval) =>
              approval.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              approval.supervisor.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }
}
