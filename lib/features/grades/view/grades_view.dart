import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/grades_controller.dart';
import '../model/grade_model.dart';

class GradesView extends StatelessWidget {
  const GradesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Consumer<GradesController>(
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
                  'رصد الدرجات',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'إدارة ورصد درجات أبحاث التخرج',
                  style: TextStyle(color: AppColors.gray500, fontSize: 14),
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
                            title: 'إجمالي الأبحاث',
                            value: controller.totalCount.toString(),
                            bgColor: Colors.white,
                            textColor: AppColors.foreground,
                            borderColor: AppColors.gray200,
                          ),
                        ),
                        if (!isMobile) const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'بانتظار المشرف',
                            value:
                                controller.waitingSupervisorCount.toString(),
                            bgColor: const Color(0xFFFEF2F2),
                            textColor: const Color(0xFFDC2626),
                            borderColor: const Color(0xFFFECACA),
                          ),
                        ),
                        if (!isMobile) const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'بانتظار المسؤول',
                            value: controller.waitingAdminCount.toString(),
                            bgColor: const Color(0xFFFFF7ED),
                            textColor: const Color(0xFFEA580C),
                            borderColor: const Color(0xFFFFEDD5),
                          ),
                        ),
                        if (!isMobile) const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'مكتملة',
                            value: controller.completedCount.toString(),
                            bgColor: const Color(0xFFF0FDF4),
                            textColor: const Color(0xFF16A34A),
                            borderColor: const Color(0xFF86EFAC),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Filter Chips
                _buildFilterChips(controller),
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
                      hintText: 'البحث عن مجموعة...',
                      hintStyle: TextStyle(color: AppColors.gray400),
                      border: InputBorder.none,
                      suffixIcon:
                          Icon(Icons.search, color: AppColors.gray400),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Grades List
                if (controller.grades.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Column(
                        children: [
                          Icon(Icons.inbox_outlined,
                              size: 64, color: AppColors.gray300),
                          const SizedBox(height: 16),
                          const Text(
                            'لا توجد أبحاث في هذه الحالة',
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
                    itemCount: controller.grades.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final grade = controller.grades[index];
                      return _buildGradeCard(context, controller, grade);
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChips(GradesController controller) {
    final filters = ['الكل', 'بانتظار المشرف', 'بانتظار المسؤول', 'مكتملة'];
    final filterColors = {
      'الكل': const Color(0xFF2563EB),
      'بانتظار المشرف': const Color(0xFFDC2626),
      'بانتظار المسؤول': const Color(0xFFEA580C),
      'مكتملة': const Color(0xFF16A34A),
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = controller.statusFilter == filter;
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
              color: textColor == AppColors.foreground
                  ? AppColors.gray600
                  : textColor,
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

  Widget _buildGradeCard(BuildContext context, GradesController controller,
      GradeModel grade) {
    Color badgeBgColor;
    Color badgeTextColor;

    switch (grade.gradeStatus) {
      case 'بانتظار المشرف':
        badgeBgColor = const Color(0xFFFEF2F2);
        badgeTextColor = const Color(0xFFDC2626);
        break;
      case 'بانتظار المسؤول':
        badgeBgColor = const Color(0xFFFFF7ED);
        badgeTextColor = const Color(0xFFEA580C);
        break;
      case 'مكتملة':
        badgeBgColor = const Color(0xFFF0FDF4);
        badgeTextColor = const Color(0xFF16A34A);
        break;
      default:
        badgeBgColor = AppColors.gray100;
        badgeTextColor = AppColors.gray600;
    }

    final finalGrade = grade.finalGrade ?? 0.0;

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
          // Header row: badge + group name
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
                  grade.gradeStatus,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  grade.groupName,
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

          const SizedBox(height: 16),
          if (grade.students.isNotEmpty) ...[
            const Text(
              'درجات الطلاب:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            ...grade.students.map((student) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      student.programManagerGrade != null
                          ? '${student.programManagerGrade} / 40'
                          : '- / 40',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: student.programManagerGrade != null 
                            ? AppColors.primary 
                            : AppColors.gray500,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        student.studentName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.gray700,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
          const Divider(color: AppColors.gray200),
          const SizedBox(height: 16),

          // Grades display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Final total
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('المجموع',
                        style: TextStyle(
                            fontSize: 13, color: AppColors.gray500)),
                    const SizedBox(height: 8),
                    Text(
                      '${finalGrade.toStringAsFixed(1)} / 100',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: finalGrade >= 60
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.gray200),
              // Program manager grade
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('درجة المسؤول',
                        style: TextStyle(
                            fontSize: 13, color: AppColors.gray500)),
                    const SizedBox(height: 8),
                    Text(
                      grade.programManagerGrade != null
                          ? '${grade.programManagerGrade} / 40'
                          : '- / 40',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB)),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.gray200),
              // Supervisor grade
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('درجة المشرف',
                        style: TextStyle(
                            fontSize: 13, color: AppColors.gray500)),
                    const SizedBox(height: 8),
                    Text(
                      grade.supervisorGrade != null
                          ? '${grade.supervisorGrade} / 60'
                          : '- / 60',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: grade.supervisorGrade == null
                  ? null
                  : () => _showAddGradeDialog(context, controller, grade),
              icon: const Icon(Icons.edit, size: 16, color: Colors.white),
              label: Text(
                grade.programManagerGrade == null
                    ? 'رصد درجات الطلاب'
                    : 'تعديل درجات الطلاب',
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                disabledBackgroundColor: AppColors.gray300,
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

  void _showAddGradeDialog(BuildContext context, GradesController controller,
      GradeModel grade) {
    // Map to hold controllers for each student
    final studentControllers = <int, TextEditingController>{};
    for (final student in grade.students) {
      studentControllers[student.studentId] = TextEditingController(
        text: student.programManagerGrade != null
            ? student.programManagerGrade.toString()
            : '',
      );
    }
    
    String? errorText;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text('رصد الدرجات للطلاب', textAlign: TextAlign.right),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'أدخل درجة مسؤول البرنامج لطلاب المجموعة "${grade.groupName}"',
                    textAlign: TextAlign.right,
                    style:
                        const TextStyle(fontSize: 14, color: AppColors.gray700),
                  ),
                  const SizedBox(height: 16),
                  if (errorText != null) ...[
                    Text(
                      errorText!,
                      style: const TextStyle(color: AppColors.error, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (grade.students.isEmpty)
                    const Center(
                      child: Text('لا يوجد طلاب في هذه المجموعة',
                          style: TextStyle(color: AppColors.gray500)),
                    )
                  else
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: grade.students.length,
                        itemBuilder: (context, index) {
                          final student = grade.students[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: TextField(
                                    controller: studentControllers[student.studentId],
                                    textAlign: TextAlign.center,
                                    keyboardType: const TextInputType.numberWithOptions(
                                        decimal: true),
                                    decoration: InputDecoration(
                                      hintText: 'من 40',
                                      hintStyle:
                                          const TextStyle(color: AppColors.gray400, fontSize: 12),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    student.studentName,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.start,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('إلغاء',
                    style: TextStyle(color: AppColors.gray600)),
              ),
              ElevatedButton(
                onPressed: grade.students.isEmpty ? null : () {
                  final studentGradesMap = <int, double>{};
                  bool hasError = false;

                  for (final entry in studentControllers.entries) {
                    final text = entry.value.text.trim();
                    if (text.isEmpty) {
                      setState(() => errorText = 'يرجى إدخال جميع الدرجات');
                      hasError = true;
                      break;
                    }
                    final parsedGrade = double.tryParse(text);
                    if (parsedGrade == null) {
                      setState(() => errorText = 'يرجى إدخال أرقام صحيحة');
                      hasError = true;
                      break;
                    }
                    if (parsedGrade < 0 || parsedGrade > 40) {
                      setState(() =>
                          errorText = 'يجب أن تكون الدرجات بين 0 و 40');
                      hasError = true;
                      break;
                    }
                    studentGradesMap[entry.key] = parsedGrade;
                  }

                  if (!hasError && grade.gradeId != null) {
                    controller.updateProgramManagerGrades(
                        grade.gradeId!, grade.groupId, studentGradesMap);
                    Navigator.of(ctx).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                ),
                child: const Text('حفظ',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }
}
