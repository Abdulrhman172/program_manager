import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/approval_controller.dart';
import '../model/approval_model.dart';

class ApprovalView extends StatelessWidget {
  const ApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Consumer<ApprovalController>(
          builder: (context, controller, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'اعتماد المرحلة الأولى',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'مراجعة واعتماد عناوين الأبحاث',
                  style: TextStyle(
                    color: AppColors.gray500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Cards
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'في الانتظار',
                            value: controller.pendingCount.toString(),
                            bgColor: const Color(0xFFFFF7ED),
                            textColor: const Color(0xFFEA580C),
                            borderColor: const Color(0xFFFFEDD5),
                          ),
                        ),
                        if (!isMobile) const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'المعتمدة',
                            value: controller.approvedCount.toString(),
                            bgColor: const Color(0xFFF0FDF4),
                            textColor: const Color(0xFF16A34A),
                            borderColor: const Color(0xFF86EFAC),
                          ),
                        ),
                        if (!isMobile) const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'المرفوضة',
                            value: controller.rejectedCount.toString(),
                            bgColor: const Color(0xFFFEF2F2),
                            textColor: const Color(0xFFDC2626),
                            borderColor: const Color(0xFFFECACA),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gray200),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: controller.search,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      hintText: 'البحث عن مشروع...',
                      hintStyle: TextStyle(color: AppColors.gray400),
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search, color: AppColors.gray400),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Projects List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.approvals.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final approval = controller.approvals[index];
                    return _buildProjectCard(context, controller, approval);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color bgColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, ApprovalController controller, ApprovalModel approval) {
    Color badgeBgColor;
    Color badgeTextColor;

    switch (approval.status) {
      case 'في الانتظار':
        badgeBgColor = const Color(0xFFFFF7ED);
        badgeTextColor = const Color(0xFFEA580C);
        break;
      case 'معتمدة':
        badgeBgColor = const Color(0xFFF0FDF4);
        badgeTextColor = const Color(0xFF16A34A);
        break;
      case 'مرفوضة':
        badgeBgColor = const Color(0xFFFEF2F2);
        badgeTextColor = const Color(0xFFDC2626);
        break;
      default:
        badgeBgColor = AppColors.gray100;
        badgeTextColor = AppColors.gray600;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  approval.status,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      approval.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.foreground,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'التخصص: ${approval.department}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.gray500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'أعضاء الفريق: ${approval.members.join(' - ')}',
                style: const TextStyle(fontSize: 13, color: AppColors.gray600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'المشرف: ${approval.supervisor}',
                style: const TextStyle(fontSize: 13, color: AppColors.gray600),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  controller.changeStatus(approval.id, 'مرفوضة');
                },
                icon: const Icon(Icons.close, size: 16, color: Colors.white),
                label: const Text('رفض', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626), // Red
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  controller.changeStatus(approval.id, 'معتمدة');
                },
                icon: const Icon(Icons.check, size: 16, color: Colors.white),
                label: const Text('اعتماد', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A), // Green
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {
                  _showDetailsModal(context, approval);
                },
                icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                label: const Text('عرض التفاصيل'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.foreground,
                  side: const BorderSide(color: AppColors.gray300),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDetailsModal(BuildContext context, ApprovalModel approval) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  approval.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 16),
                const Text('الوصف:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(approval.description, style: const TextStyle(fontSize: 14, color: AppColors.gray700), textAlign: TextAlign.right),
                
                const SizedBox(height: 16),
                const Text('التخصص:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(approval.department, style: const TextStyle(fontSize: 14, color: AppColors.gray700), textAlign: TextAlign.right),
                
                const SizedBox(height: 16),
                const Text('أعضاء الفريق:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                ...approval.members.map((member) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(member, style: const TextStyle(fontSize: 14, color: AppColors.gray700)),
                      const SizedBox(width: 8),
                      const Icon(Icons.circle, size: 6, color: AppColors.gray700),
                    ],
                  ),
                )),
                
                const SizedBox(height: 16),
                const Text('المشرف الأكاديمي:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(approval.supervisor, style: const TextStyle(fontSize: 14, color: AppColors.gray700)),
                
                const SizedBox(height: 16),
                const Text('تاريخ التقديم:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(approval.submissionDate, style: const TextStyle(fontSize: 14, color: AppColors.gray700)),
                
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.gray300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('إغلاق', style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
