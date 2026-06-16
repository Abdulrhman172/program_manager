import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/supervisors_controller.dart';
import '../model/supervisor_model.dart';

class SupervisorsView extends StatelessWidget {
  const SupervisorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Consumer<SupervisorsController>(
        builder: (context, controller, _) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'إدارة المشرفين',
                                style:
                                    Theme.of(context).textTheme.displaySmall,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'إنشاء وإدارة حسابات المشرفين الأكاديميين في برنامجك',
                                style: TextStyle(
                                  color: AppColors.gray500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: controller.openAddForm,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('إضافة مشرف'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    if (controller.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(80),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (controller.errorMessage != null)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Text(
                            controller.errorMessage!,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                      )
                    else ...[
                      // Stats Cards
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile = constraints.maxWidth < 600;
                          if (isMobile) {
                            return Column(
                              children: [
                                _buildStatCard(
                                  title: 'إجمالي المشرفين',
                                  value:
                                      controller.totalSupervisors.toString(),
                                  bgColor: Colors.white,
                                  textColor: AppColors.foreground,
                                  borderColor: AppColors.gray200,
                                  icon: Icons.people_outline,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatCard(
                                        title: 'مفعّلون',
                                        value: controller.activeSupervisors
                                            .toString(),
                                        bgColor: const Color(0xFFF0FDF4),
                                        textColor: AppColors.success,
                                        borderColor: const Color(0xFF86EFAC),
                                        icon: Icons.check_circle_outline,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildStatCard(
                                        title: 'غير مفعّلين',
                                        value: controller.inactiveSupervisors
                                            .toString(),
                                        bgColor: const Color(0xFFFEF2F2),
                                        textColor: AppColors.error,
                                        borderColor: const Color(0xFFFECACA),
                                        icon: Icons.cancel_outlined,
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
                                  value:
                                      controller.totalSupervisors.toString(),
                                  bgColor: Colors.white,
                                  textColor: AppColors.foreground,
                                  borderColor: AppColors.gray200,
                                  icon: Icons.people_outline,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  title: 'المشرفين المفعلين',
                                  value:
                                      controller.activeSupervisors.toString(),
                                  bgColor: const Color(0xFFF0FDF4),
                                  textColor: AppColors.success,
                                  borderColor: const Color(0xFF86EFAC),
                                  icon: Icons.check_circle_outline,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  title: 'المشرفين غير المفعلين',
                                  value: controller.inactiveSupervisors
                                      .toString(),
                                  bgColor: const Color(0xFFFEF2F2),
                                  textColor: AppColors.error,
                                  borderColor: const Color(0xFFFECACA),
                                  icon: Icons.cancel_outlined,
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
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          onChanged: controller.search,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            hintText: 'البحث عن مشرف...',
                            hintStyle:
                                TextStyle(color: AppColors.gray400),
                            border: InputBorder.none,
                            suffixIcon: Icon(Icons.search,
                                color: AppColors.gray400),
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
                                minWidth:
                                    MediaQuery.of(context).size.width -
                                        300,
                              ),
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(
                                    const Color(0xFFF8FAFC)),
                                headingTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.foreground,
                                  fontFamily: 'Tajawal',
                                ),
                                dataRowMaxHeight: 64,
                                dataRowMinHeight: 64,
                                columns: const [
                                  DataColumn(label: Text('#')),
                                  DataColumn(label: Text('اسم المشرف')),
                                  DataColumn(
                                      label: Text('اسم المستخدم')),
                                  DataColumn(
                                      label:
                                          Text('البريد الإلكتروني')),
                                  DataColumn(label: Text('رقم الهاتف')),
                                  DataColumn(
                                      label: Text('عدد الأبحاث')),
                                  DataColumn(label: Text('الحالة')),
                                  DataColumn(
                                      label: Text('الإجراءات')),
                                ],
                                rows: controller.supervisors
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final index = entry.key;
                                  final supervisor = entry.value;
                                  return DataRow(
                                    color: WidgetStateProperty
                                        .resolveWith<Color?>(
                                      (Set<WidgetState> states) {
                                        return index.isEven
                                            ? Colors.white
                                            : const Color(0xFFF8FAFC)
                                                .withAlpha(128);
                                      },
                                    ),
                                    cells: [
                                      DataCell(Text('${index + 1}')),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor:
                                                  AppColors.primary
                                                      .withAlpha(30),
                                              child: Text(
                                                supervisor.name.isNotEmpty
                                                    ? supervisor.name[0]
                                                    : '?',
                                                style: const TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              supervisor.name,
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(Text(
                                          supervisor.username ?? '-',
                                          style: const TextStyle(
                                              color: AppColors.gray600,
                                              fontSize: 13))),
                                      DataCell(
                                          Text(supervisor.email)),
                                      DataCell(Text(
                                          supervisor.phoneNum ?? '-')),
                                      DataCell(Center(
                                          child: Text(supervisor
                                              .researchCount
                                              .toString()))),
                                      DataCell(
                                        Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 4),
                                          decoration: BoxDecoration(
                                            color: supervisor.isActive
                                                ? const Color(0xFFDCFCE7)
                                                : const Color(0xFFFEE2E2),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            supervisor.isActive
                                                ? 'مفعّل'
                                                : 'غير مفعّل',
                                            style: TextStyle(
                                              color: supervisor.isActive
                                                  ? const Color(0xFF166534)
                                                  : const Color(0xFF991B1B),
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
                                            // Toggle
                                            Switch(
                                              value: supervisor.isActive,
                                              onChanged: (value) {
                                                controller
                                                    .toggleSupervisorStatus(
                                                        supervisor.id,
                                                        value);
                                              },
                                              activeThumbColor:
                                                  Colors.white,
                                              activeTrackColor:
                                                  AppColors.primary,
                                              inactiveThumbColor:
                                                  Colors.white,
                                              inactiveTrackColor:
                                                  AppColors.gray300,
                                            ),
                                            const SizedBox(width: 4),
                                            // Edit button
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.edit_outlined,
                                                  size: 18),
                                              color: AppColors.gray600,
                                              tooltip: 'تعديل',
                                              onPressed: () =>
                                                  controller.openEditForm(
                                                      supervisor),
                                            ),
                                            // Delete button
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.delete_outline,
                                                  size: 18),
                                              color: AppColors.error,
                                              tooltip: 'حذف',
                                              onPressed: () =>
                                                  _confirmDelete(context,
                                                      controller, supervisor),
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

                      if (controller.supervisors.isEmpty &&
                          !controller.isLoading)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: const Column(
                            children: [
                              Icon(Icons.person_off_outlined,
                                  size: 64, color: AppColors.gray300),
                              SizedBox(height: 16),
                              Text('لا يوجد مشرفون مضافون',
                                  style: TextStyle(
                                      color: AppColors.gray500, fontSize: 16)),
                              SizedBox(height: 8),
                              Text(
                                  'اضغط على "إضافة مشرف" لإضافة مشرف جديد',
                                  style: TextStyle(
                                      color: AppColors.gray400, fontSize: 13)),
                            ],
                          ),
                        ),
                    ],
                  ],
                ),
              ),

              // Side Panel Overlay
              if (controller.isFormVisible)
                _buildFormPanel(context, controller),
            ],
          );
        },
      ),
    );
  }

  // Confirmation dialog for delete
  void _confirmDelete(BuildContext context, SupervisorsController controller,
      SupervisorModel supervisor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تأكيد الحذف', textAlign: TextAlign.right),
        content: Text(
          'هل أنت متأكد من حذف المشرف "${supervisor.name}"؟\nلا يمكن التراجع عن هذا الإجراء.',
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 14, color: AppColors.gray700),
        ),
        actionsAlignment: MainAxisAlignment.start,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteSupervisor(supervisor.id, context);
            },
            child: const Text('حذف'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  // Side form panel
  Widget _buildFormPanel(
      BuildContext context, SupervisorsController controller) {
    return Positioned.fill(
      child: Row(
        children: [
          // Dimmed background
          Expanded(
            child: GestureDetector(
              onTap: controller.closeForm,
              child: Container(color: Colors.black.withAlpha(80)),
            ),
          ),
          // Form panel
          Container(
            width: 420,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(-4, 0),
                )
              ],
            ),
            child: Column(
              children: [
                // Panel Header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    border: Border(
                        bottom: BorderSide(color: AppColors.gray200)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: controller.closeForm,
                        color: AppColors.gray600,
                      ),
                      const Spacer(),
                      Text(
                        controller.isEditing
                            ? 'تعديل بيانات المشرف'
                            : 'إضافة مشرف جديد',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.foreground,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        controller.isEditing
                            ? Icons.edit_outlined
                            : Icons.person_add_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),

                // Form Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Error message
                        if (controller.formError != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: const Color(0xFFFECACA)),
                            ),
                            child: Text(
                              controller.formError!,
                              style: const TextStyle(
                                  color: AppColors.error, fontSize: 13),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        _buildFormField(
                          label: 'الاسم الكامل *',
                          controller: controller.nameController,
                          hint: 'مثال: أ. محمد أحمد',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          label: 'البريد الإلكتروني *',
                          controller: controller.emailController,
                          hint: 'example@university.edu.ye',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          label: 'رقم الهاتف',
                          controller: controller.phoneController,
                          hint: '77xxxxxxx',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          label: 'اسم المستخدم *',
                          controller: controller.usernameController,
                          hint: 'مثال: mohammed.supervisor',
                          icon: Icons.alternate_email,
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (controller.isEditing)
                                  const Text(
                                    '(اتركها فارغة للإبقاء على القديمة)',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.gray500),
                                  ),
                                if (controller.isEditing)
                                  const SizedBox(width: 6),
                                Text(
                                  controller.isEditing
                                      ? 'كلمة المرور'
                                      : 'كلمة المرور *',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.gray700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Consumer<SupervisorsController>(
                              builder: (context, ctrl, _) => TextFormField(
                                controller: ctrl.passwordController,
                                obscureText: ctrl.obscurePassword,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.ltr,
                                style: const TextStyle(
                                    fontFamily: 'Tajawal', fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  hintStyle: const TextStyle(
                                      color: AppColors.gray400),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: AppColors.gray200),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: AppColors.gray200),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: AppColors.primary, width: 1.5),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      ctrl.obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppColors.gray400,
                                      size: 20,
                                    ),
                                    onPressed: ctrl.togglePasswordVisibility,
                                  ),
                                  prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: AppColors.gray400,
                                      size: 18),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: controller.closeForm,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                  side: const BorderSide(
                                      color: AppColors.gray300),
                                ),
                                child: const Text('إلغاء',
                                    style: TextStyle(
                                        color: AppColors.gray700)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: controller.isSaving
                                    ? null
                                    : controller.saveSupervisor,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                ),
                                child: controller.isSaving
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        controller.isEditing
                                            ? 'حفظ التعديلات'
                                            : 'إضافة المشرف',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? hint,
    IconData? icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
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
        TextFormField(
          controller: controller,
          textAlign: TextAlign.right,
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.gray400),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            prefixIcon: icon != null
                ? Icon(icon, color: AppColors.gray400, size: 18)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color bgColor,
    required Color textColor,
    required Color borderColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon,
              color: textColor == AppColors.foreground
                  ? AppColors.gray400
                  : textColor,
              size: 32),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textColor == AppColors.foreground
                      ? AppColors.gray600
                      : textColor,
                ),
              ),
              const SizedBox(height: 4),
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
        ],
      ),
    );
  }
}
