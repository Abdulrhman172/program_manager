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
            if (controller.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(80),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (controller.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text(
                    controller.errorMessage!,
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
              );
            }
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
                  style: TextStyle(color: AppColors.gray500, fontSize: 14),
                ),
                const SizedBox(height: 24),

                // Stats Cards
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    if (isMobile) {
                      return Column(
                        children: [
                          Row(
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
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  title: 'المعتمدة',
                                  value: controller.approvedCount.toString(),
                                  bgColor: const Color(0xFFF0FDF4),
                                  textColor: const Color(0xFF16A34A),
                                  borderColor: const Color(0xFF86EFAC),
                                ),
                              ),
                              const SizedBox(width: 16),
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
                          ),
                        ],
                      );
                    }
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'المعتمدة',
                            value: controller.approvedCount.toString(),
                            bgColor: const Color(0xFFF0FDF4),
                            textColor: const Color(0xFF16A34A),
                            borderColor: const Color(0xFF86EFAC),
                          ),
                        ),
                        const SizedBox(width: 16),
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
                const SizedBox(height: 20),

                // Filter Chips
                _buildFilterChips(context, controller),
                const SizedBox(height: 20),

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
                      suffixIcon:
                          Icon(Icons.search, color: AppColors.gray400),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Projects List
                if (controller.approvals.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Column(
                        children: [
                          Icon(Icons.inbox_outlined,
                              size: 64, color: AppColors.gray300),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد مشاريع في هذه الحالة',
                            style: TextStyle(
                                color: AppColors.gray500, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.approvals.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final approval = controller.approvals[index];
                      return _buildProjectCard(
                          context, controller, approval);
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChips(
      BuildContext context, ApprovalController controller) {
    final filters = ['الكل', 'في الانتظار', 'معتمدة', 'مرفوضة'];
    final filterColors = {
      'الكل': const Color(0xFF2563EB),
      'في الانتظار': const Color(0xFFEA580C),
      'معتمدة': const Color(0xFF16A34A),
      'مرفوضة': const Color(0xFFDC2626),
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = controller.currentFilter == filter;
          final color = filterColors[filter] ?? AppColors.primary;
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (_) => controller.setFilter(filter),
              selectedColor: color,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.gray700,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              side: BorderSide(
                  color: isSelected ? color : AppColors.gray200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              showCheckmark: false,
            ),
          );
        }).toList(),
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
                color: textColor),
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

  Widget _buildProjectCard(BuildContext context, ApprovalController controller,
      ApprovalModel approval) {
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
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
                child: Text(
                  approval.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          if (approval.description != null) ...[
            const SizedBox(height: 8),
            Text(
              approval.description!,
              style:
                  const TextStyle(fontSize: 13, color: AppColors.gray600),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // موافقات الأطراف الأخرى
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildMiniApprovalBadge(
                  'المشرف', approval.sprvsrApproval),
              const SizedBox(width: 8),
              _buildMiniApprovalBadge(
                  'رئيس القسم', approval.headDepApproval),
            ],
          ),
          // سبب الرفض
          if (approval.status == 'مرفوضة' &&
              approval.rejectionReason != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Text(
                'سبب الرفض: ${approval.rejectionReason}',
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFFDC2626)),
                textAlign: TextAlign.right,
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () =>
                  _showDetailsModal(context, controller, approval),
              icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
              label: const Text('عرض التفاصيل'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.foreground,
                side: const BorderSide(color: AppColors.gray300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniApprovalBadge(String label, bool? approved) {
    Color bg, text;
    String approvalText;
    if (approved == true) {
      bg = const Color(0xFFF0FDF4);
      text = const Color(0xFF16A34A);
      approvalText = 'وافق';
    } else if (approved == false) {
      bg = const Color(0xFFFEF2F2);
      text = const Color(0xFFDC2626);
      approvalText = 'رفض';
    } else {
      bg = const Color(0xFFFFF7ED);
      text = const Color(0xFFEA580C);
      approvalText = 'بانتظار';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(
        '$label: $approvalText',
        style:
            TextStyle(fontSize: 11, color: text, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showConfirmApproveDialog(BuildContext context,
      ApprovalController controller, ApprovalModel approval) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تأكيد الاعتماد', textAlign: TextAlign.right),
        content: Text(
          'هل أنت متأكد من اعتماد مشروع "${approval.title}"؟',
          textAlign: TextAlign.right,
        ),
        actionsAlignment: MainAxisAlignment.start,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('لا',
                style: TextStyle(color: AppColors.gray600)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.changeStatus(approval.stage1Id, true);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
            ),
            child: const Text('نعم، اعتماد',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showRejectionReasonDialog(BuildContext context,
      ApprovalController controller, ApprovalModel approval) {
    final reasonController = TextEditingController();
    String? errorText;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text('سبب الرفض', textAlign: TextAlign.right),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'يرجى كتابة سبب رفض مشروع "${approval.title}":',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.gray700),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'اكتب سبب الرفض هنا...',
                    hintStyle:
                        const TextStyle(color: AppColors.gray400),
                    errorText: errorText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: AppColors.gray200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: AppColors.primary),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.start,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('غير موافق',
                    style: TextStyle(color: AppColors.gray600)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (reasonController.text.trim().isEmpty) {
                    setState(() => errorText = 'يرجى كتابة سبب الرفض');
                    return;
                  }
                  controller.changeStatus(approval.stage1Id, false,
                      reason: reasonController.text.trim());
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                ),
                child: const Text('موافق، رفض',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDetailsModal(BuildContext context, ApprovalController controller,
      ApprovalModel approval) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 520,
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Title + status badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusBadge(approval.status),
                      Expanded(
                        child: Text(
                          approval.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.foreground,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (approval.description != null) ...[
                    const Text('الوصف:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(approval.description!,
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.gray700),
                        textAlign: TextAlign.right),
                    const SizedBox(height: 16),
                  ],

                  // موافقات الأطراف
                  const Text('حالة الموافقات:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildMiniApprovalBadge(
                          'المشرف', approval.sprvsrApproval),
                      const SizedBox(width: 8),
                      _buildMiniApprovalBadge(
                          'مدير البرنامج', approval.prgrmMngrApproval),
                      const SizedBox(width: 8),
                      _buildMiniApprovalBadge(
                          'رئيس القسم', approval.headDepApproval),
                    ],
                  ),

                  // ملاحظات المشرف
                  if (approval.sprvsrNote != null &&
                      approval.sprvsrNote!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('ملاحظة المشرف:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(approval.sprvsrNote!,
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.gray700)),
                  ],

                  if (approval.rejectionReason != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xFFFECACA)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('سبب الرفض:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFFDC2626))),
                          const SizedBox(height: 4),
                          Text(approval.rejectionReason!,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFDC2626)),
                              textAlign: TextAlign.right),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  const Divider(color: AppColors.gray200),
                  const SizedBox(height: 16),

                  // Action Buttons — only if pending
                  if (approval.status == 'في الانتظار') ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showRejectionReasonDialog(
                                context, controller, approval),
                            icon: const Icon(Icons.close,
                                size: 16, color: Colors.white),
                            label: const Text('رفض',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDC2626),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showConfirmApproveDialog(
                                context, controller, approval),
                            icon: const Icon(Icons.check,
                                size: 16, color: Colors.white),
                            label: const Text('اعتماد',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF16A34A),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.gray300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('إغلاق',
                          style: TextStyle(
                              color: AppColors.foreground,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg, text;
    switch (status) {
      case 'في الانتظار':
        bg = const Color(0xFFFFF7ED);
        text = const Color(0xFFEA580C);
        break;
      case 'معتمدة':
        bg = const Color(0xFFF0FDF4);
        text = const Color(0xFF16A34A);
        break;
      case 'مرفوضة':
        bg = const Color(0xFFFEF2F2);
        text = const Color(0xFFDC2626);
        break;
      default:
        bg = AppColors.gray100;
        text = AppColors.gray600;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status,
          style: TextStyle(
              color: text, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}
