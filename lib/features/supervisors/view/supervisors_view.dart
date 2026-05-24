import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/supervisors_controller.dart';

class SupervisorsView extends StatelessWidget {
  const SupervisorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Consumer<SupervisorsController>(
          builder: (context, controller, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'تفعيل وإيقاف المشرفين',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'إدارة حالة المشرفين الأكاديميين في النظام',
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
                    if (isMobile) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  title: 'إجمالي المشرفين',
                                  value: controller.totalSupervisors.toString(),
                                  bgColor: Colors.white,
                                  textColor: AppColors.foreground,
                                  borderColor: AppColors.gray200,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  title: 'المشرفين المفعلين',
                                  value: controller.activeSupervisors.toString(),
                                  bgColor: const Color(0xFFF0FDF4),
                                  textColor: AppColors.success,
                                  borderColor: const Color(0xFF86EFAC),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  title: 'المشرفين غير المفعلين',
                                  value: controller.inactiveSupervisors.toString(),
                                  bgColor: const Color(0xFFFEF2F2),
                                  textColor: AppColors.error,
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
                            title: 'إجمالي المشرفين',
                            value: controller.totalSupervisors.toString(),
                            bgColor: Colors.white,
                            textColor: AppColors.foreground,
                            borderColor: AppColors.gray200,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'المشرفين المفعلين',
                            value: controller.activeSupervisors.toString(),
                            bgColor: const Color(0xFFF0FDF4),
                            textColor: AppColors.success,
                            borderColor: const Color(0xFF86EFAC),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'المشرفين غير المفعلين',
                            value: controller.inactiveSupervisors.toString(),
                            bgColor: const Color(0xFFFEF2F2),
                            textColor: AppColors.error,
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
                      hintText: 'البحث عن مشرف...',
                      hintStyle: TextStyle(color: AppColors.gray400),
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search, color: AppColors.gray400),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Supervisors Table
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gray200),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width - 300,
                        ),
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                          headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.foreground,
                            fontFamily: 'Tajawal',
                          ),
                          dataRowMaxHeight: 60,
                          dataRowMinHeight: 60,
                          columns: const [
                            DataColumn(label: Text('#')),
                            DataColumn(label: Text('اسم المشرف')),
                            DataColumn(label: Text('القسم')),
                            DataColumn(label: Text('البريد الإلكتروني')),
                            DataColumn(label: Text('عدد الأبحاث')),
                            DataColumn(label: Text('الحالة')),
                            DataColumn(label: Text('الإجراء')),
                          ],
                          rows: controller.supervisors.asMap().entries.map((entry) {
                            final index = entry.key;
                            final supervisor = entry.value;
                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  return index.isEven ? Colors.white : const Color(0xFFF8FAFC).withAlpha(128);
                                },
                              ),
                              cells: [
                                DataCell(Text('${index + 1}')),
                                DataCell(Text(supervisor.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                                DataCell(Text(supervisor.department)),
                                DataCell(Text(supervisor.email)),
                                DataCell(Center(child: Text(supervisor.researchCount.toString()))),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: supervisor.isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      supervisor.isActive ? 'مفعل' : 'غير مفعل',
                                      style: TextStyle(
                                        color: supervisor.isActive ? const Color(0xFF166534) : const Color(0xFF991B1B),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        supervisor.isActive ? 'إيقاف' : 'تفعيل',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: supervisor.isActive ? AppColors.gray500 : AppColors.success,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Switch(
                                        value: supervisor.isActive,
                                        onChanged: (value) {
                                          controller.toggleSupervisorStatus(supervisor.id, value);
                                        },
                                        activeThumbColor: Colors.white,
                                        activeTrackColor: Colors.black,
                                        inactiveThumbColor: Colors.white,
                                        inactiveTrackColor: AppColors.gray300,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
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
              color: textColor == AppColors.foreground ? AppColors.gray600 : textColor,
            ),
          ),
          const SizedBox(height: 8),
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
}
