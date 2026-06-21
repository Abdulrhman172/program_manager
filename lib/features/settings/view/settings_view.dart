import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/settings_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإعدادات'),
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'الملف الشخصي'),
              Tab(text: 'الأمان'),
            ],
          ),
        ),
        body: Consumer<SettingsController>(
          builder: (context, controller, child) {
            if (controller.isLoading && controller.currentUser == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProfileTab(context, controller),
                    _buildSecurityTab(context, controller),
                  ],
                ),
                if (controller.isLoading && controller.currentUser != null)
                  Container(
                    color: Colors.black.withValues(alpha: 0.1),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context, SettingsController controller) {
    // Show messages if any
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(controller.errorMessage!), backgroundColor: Colors.red),
        );
        controller.clearMessages();
      }
      if (controller.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(controller.successMessage!), backgroundColor: Colors.green),
        );
        controller.clearMessages();
      }
    });

    final hasImage = controller.currentUser?.prmaImage != null && controller.currentUser!.prmaImage!.isNotEmpty;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الملف الشخصي',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 4),
            const Text(
              'إدارة بيانات حسابك الشخصية',
              style: TextStyle(color: AppColors.gray600),
            ),
            const SizedBox(height: 24),

            // Profile Picture
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.gray200,
                      borderRadius: BorderRadius.circular(12),
                      image: hasImage ? DecorationImage(
                        image: NetworkImage(controller.currentUser!.prmaImage!),
                        fit: BoxFit.cover,
                      ) : null,
                    ),
                    child: !hasImage
                        ? const Center(
                            child: Icon(Icons.person, size: 40, color: AppColors.gray500),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  if (hasImage)
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.pickAndUploadImage,
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('تغيير الصورة'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _confirmDeleteImage(context, controller),
                          icon: const Icon(Icons.delete, size: 18),
                          label: const Text('حذف'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ],
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: controller.pickAndUploadImage,
                      icon: const Icon(Icons.upload, size: 18),
                      label: const Text('أضف صورة'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form Fields
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: 'الاسم الكامل',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'رقم الهاتف',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: 'مسؤول البرنامج',
              enabled: false,
              decoration: InputDecoration(
                labelText: 'المنصب',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.updateProfile,
                child: const Text('حفظ التغييرات'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityTab(BuildContext context, SettingsController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الأمان',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 4),
            const Text(
              'إدارة كلمة المرور والجلسات النشطة',
              style: TextStyle(color: AppColors.gray600),
            ),
            const SizedBox(height: 24),

            // Change Password Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تغيير كلمة المرور',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.currentPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور الحالية',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller.newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور الجديدة',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller.confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.updatePassword,
                      child: const Text('تحديث كلمة المرور'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Active Sessions
            Text(
              'الجلسات النشطة',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'الجهاز الحالي',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'تطبيق ويندوز المكتبي',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'نشط الآن',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
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
    );
  }

  Future<void> _confirmDeleteImage(BuildContext context, SettingsController controller) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف الصورة الشخصية؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await controller.deleteImage();
    }
  }
}
