import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/students_controller.dart';

class StudentsView extends StatelessWidget {
  const StudentsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the controller if not already provided higher up.
    // Assuming it's not provided globally, we provide it here locally.
    return ChangeNotifierProvider(
      create: (_) => StudentsController(),
      child: const _StudentsScreenContent(),
    );
  }
}

class _StudentsScreenContent extends StatelessWidget {
  const _StudentsScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Consumer<StudentsController>(
          builder: (context, controller, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Add Button
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 16,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إنشاء حسابات الطلاب',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'إدارة حسابات الطلاب في النظام',
                          style: TextStyle(
                            color: AppColors.gray500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.toggleAddStudentForm();
                      },
                      icon: const Icon(Icons.person_add_alt_1, color: Colors.white, size: 18),
                      label: const Text(
                        'إضافة طالب جديد',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Inline Add Form
                if (controller.isAddingStudent) _buildAddStudentForm(context, controller),

                // Search Bar
                if (!controller.isAddingStudent) ...[
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
                        hintText: 'البحث عن طالب...',
                        hintStyle: TextStyle(color: AppColors.gray400),
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.search, color: AppColors.gray400), // Suffix since RTL
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Students Table
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
                            minWidth: MediaQuery.of(context).size.width - 300, // Roughly sidebar width + padding
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
                              DataColumn(label: Text('اسم الطالب')),
                              DataColumn(label: Text('الرقم الجامعي')),
                              DataColumn(label: Text('القسم')),
                              DataColumn(label: Text('رقم الدفعة')),
                              DataColumn(label: Text('السنة الدراسية')),
                              DataColumn(label: Text('الإجراءات')),
                            ],
                            rows: controller.students.asMap().entries.map((entry) {
                              final index = entry.key;
                              final student = entry.value;
                              return DataRow(
                                color: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                    return index.isEven ? Colors.white : const Color(0xFFF8FAFC).withAlpha(128);
                                  },
                                ),
                                cells: [
                                  DataCell(Text('${index + 1}')),
                                  DataCell(Text(student.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                                  DataCell(Text(student.id)),
                                  DataCell(Text(student.department)),
                                  DataCell(Text(student.batchNumber)),
                                  DataCell(Text(student.academicYear)),
                                  DataCell(Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                                        onPressed: () {
                                          controller.openEditForm(student);
                                        },
                                        tooltip: 'تعديل',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                                        onPressed: () {
                                          controller.deleteStudent(student.id);
                                        },
                                        tooltip: 'حذف',
                                      ),
                                    ],
                                  )),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddStudentForm(BuildContext context, StudentsController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.isEditing ? 'تعديل بيانات الطالب' : 'إنشاء حساب طالب جديد',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.gray500),
                onPressed: controller.cancelAddStudent,
              ),
            ],
          ),
          
          if (controller.formError != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Text(
                controller.formError!,
                style: const TextStyle(color: AppColors.error, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          
          const SizedBox(height: 24),
          
          // Form Fields Row 1
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  label: 'اسم الطالب',
                  controller: controller.nameController,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildFormField(
                  label: 'الرقم الجامعي',
                  controller: controller.idController,
                  isNumeric: true,
                  readOnly: false, // تمكين تعديل الرقم الجامعي
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Form Fields Row 2
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'القسم',
                  value: controller.selectedDepartment,
                  items: controller.departments,
                  onChanged: controller.setSelectedDepartment,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildFormField(
                  label: 'رقم الدفعة',
                  controller: controller.batchNumberController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Form Fields Row 3
          Row(
            children: [
              Expanded(
                child: _buildAcademicYearDropdown(
                  label: 'السنة الدراسية',
                  value: controller.selectedAcademicYearId,
                  items: controller.academicYears,
                  onChanged: controller.setSelectedAcademicYear,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildFormField(
                  label: 'كلمة المرور',
                  controller: controller.passwordController,
                  obscureText: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  controller.saveStudent();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A), // Green color for save
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  controller.isEditing ? 'حفظ التعديلات' : 'حفظ وإنشاء الحساب',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: controller.cancelAddStudent,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  side: const BorderSide(color: AppColors.gray300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(color: AppColors.gray600, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    bool isNumeric = false,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          textAlign: TextAlign.right,
          readOnly: readOnly,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray700,
          ),
        ),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              isDense: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.gray500),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, textAlign: TextAlign.right),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAcademicYearDropdown({
    required String label,
    required int? value,
    required List<Map<String, dynamic>> items,
    required ValueChanged<int?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray700,
          ),
        ),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.gray200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              isDense: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.gray500),
              items: items.map((item) {
                return DropdownMenuItem<int>(
                  value: item['acye_id'] as int,
                  child: Text(item['acye_year'].toString(), textAlign: TextAlign.right),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
