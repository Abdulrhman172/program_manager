import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/research_model.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  List<ResearchProject> projects = [
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

  void _approveProject(String id) {
    setState(() {
      projects = projects.map((p) {
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
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم اعتماد البحث بنجاح')),
    );
  }

  void _rejectProject(String id) {
    setState(() {
      projects = projects.map((p) {
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
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم رفض البحث')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingProjects = projects.where((p) => p.status == 'pending').toList();
    final approvedProjects = projects.where((p) => p.status == 'approved').toList();
    final rejectedProjects = projects.where((p) => p.status == 'rejected').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('اعتماد البحوث'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'اعتماد البحوث',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 4),
              const Text(
                'مراجعة واعتماد البحوث المقدمة من الطلاب',
                style: TextStyle(color: AppColors.gray600),
              ),
              const SizedBox(height: 24),

              // Stats
              GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'قيد المراجعة',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pendingProjects.length.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(color: AppColors.warning),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'المعتمدة',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            approvedProjects.length.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(color: AppColors.success),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'المرفوضة',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            rejectedProjects.length.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Pending Projects
              if (pendingProjects.isNotEmpty) ...[
                Text(
                  'البحوث قيد المراجعة',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pendingProjects.length,
                  itemBuilder: (context, index) {
                    final project = pendingProjects[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Row(
                              children: [
                                const Icon(Icons.description,
                                    color: AppColors.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    project.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Info
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'الطالب',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.gray500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        project.studentName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'المشرف',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.gray500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        project.advisor,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'تاريخ التقديم',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.gray500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        project.submissionDate,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 12),

                            // Actions
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      _approveProject(project.id),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text('اعتماد'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.success,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: () =>
                                      _rejectProject(project.id),
                                  icon: const Icon(Icons.close, size: 18),
                                  label: const Text('رفض'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.error,
                                    side: const BorderSide(
                                        color: AppColors.error),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.visibility,
                                        size: 18),
                                    label: const Text('عرض التفاصيل'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],

              // Approved Projects
              if (approvedProjects.isNotEmpty) ...[
                Text(
                  'البحوث المعتمدة',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: approvedProjects.length,
                  itemBuilder: (context, index) {
                    final project = approvedProjects[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: AppColors.success),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  project.studentName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'معتمد',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
