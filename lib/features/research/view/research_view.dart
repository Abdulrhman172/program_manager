import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/research_controller.dart';
import '../model/research_model.dart';

class ResearchView extends StatelessWidget {
  const ResearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Consumer<ResearchController>(
          builder: (context, controller, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'الاطلاع على الأبحاث',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'عرض ومتابعة جميع أبحاث التخرج',
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
                            title: 'المرحلة المتقدمة',
                            value: controller.advancedPhaseCount.toString(),
                            bgColor: const Color(0xFFF0FDF4),
                            textColor: const Color(0xFF16A34A),
                            borderColor: const Color(0xFF86EFAC),
                          ),
                        ),
                        if (!isMobile) const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'قيد التنفيذ',
                            value: controller.inProgressCount.toString(),
                            bgColor: const Color(0xFFEFF6FF),
                            textColor: const Color(0xFF2563EB),
                            borderColor: const Color(0xFFBFDBFE),
                          ),
                        ),
                        if (!isMobile) const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'في البداية',
                            value: controller.inBeginningCount.toString(),
                            bgColor: const Color(0xFFFFF7ED),
                            textColor: const Color(0xFFEA580C),
                            borderColor: const Color(0xFFFFEDD5),
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
                      hintText: 'البحث عن بحث...',
                      hintStyle: TextStyle(color: AppColors.gray400),
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search, color: AppColors.gray400),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Projects Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 800;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isMobile ? 1 : 2,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: isMobile ? 0.8 : 1.3,
                      ),
                      itemCount: controller.researches.length,
                      itemBuilder: (context, index) {
                        return _buildResearchCard(context, controller, controller.researches[index]);
                      },
                    );
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
              color: textColor == AppColors.foreground ? AppColors.gray600 : textColor,
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

  Widget _buildResearchCard(BuildContext context, ResearchController controller, ResearchModel research) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Title
          Text(
            research.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          
          // Info List
          _buildInfoRow('المشرف:', research.supervisor),
          const SizedBox(height: 8),
          _buildInfoRow('القسم:', research.department),
          const SizedBox(height: 8),
          _buildInfoRow(
            'المرحلة الحالية:',
            research.currentPhase,
            valueColor: const Color(0xFF2563EB), // Blue
          ),
          const SizedBox(height: 8),
          _buildInfoRow('آخر تحديث:', research.lastUpdated),
          
          const SizedBox(height: 16),
          
          // Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${research.progress.toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const Text('نسبة الإنجاز', style: TextStyle(fontSize: 12, color: AppColors.gray600)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: research.progress / 100,
            backgroundColor: const Color(0xFFE2E8F0),
            color: const Color(0xFF2563EB), // Blue
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          
          const SizedBox(height: 16),
          
          // Files Section
          Text(
            'الملفات المرفقة (${research.files.length})',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.gray700),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: research.files.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    research.files[index].name,
                    style: const TextStyle(fontSize: 12, color: AppColors.gray600),
                    textAlign: TextAlign.right,
                  ),
                );
              },
            ),
          ),
          
          // Buttons
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  controller.downloadAllFiles(context);
                },
                icon: const Icon(Icons.download_outlined, size: 16),
                label: const Text('تحميل الملفات'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.foreground,
                  side: const BorderSide(color: AppColors.gray300),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showDetailsModal(context, controller, research);
                  },
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.white),
                  label: const Text('عرض التفاصيل', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB), // Blue
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color valueColor = AppColors.gray700}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(value, style: TextStyle(fontSize: 13, color: valueColor, fontWeight: valueColor == AppColors.gray700 ? FontWeight.normal : FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.gray500)),
      ],
    );
  }

  void _showDetailsModal(BuildContext context, ResearchController controller, ResearchModel research) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    research.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 24),
                  
                  _buildModalDetailRow('المشرف الأكاديمي:', research.supervisor),
                  const SizedBox(height: 12),
                  _buildModalDetailRow('القسم:', research.department),
                  const SizedBox(height: 12),
                  _buildModalDetailRow('المرحلة الحالية:', research.currentPhase, valueColor: const Color(0xFF2563EB)),
                  
                  const SizedBox(height: 24),
                  const Text('نسبة الإنجاز:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${research.progress.toInt()}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: LinearProgressIndicator(
                            value: research.progress / 100,
                            backgroundColor: const Color(0xFFE2E8F0),
                            color: const Color(0xFF2563EB),
                            minHeight: 12,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  const Text('الملفات المرفقة:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  
                  ...research.files.map((file) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.gray200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop(); // Optional: close modal on download
                            controller.downloadSingleFile(context, file.name);
                          },
                          icon: const Icon(Icons.download_outlined, size: 16),
                          label: const Text('تحميل'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.foreground,
                            side: const BorderSide(color: AppColors.gray300),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(file.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(file.size, style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                          ],
                        ),
                      ],
                    ),
                  )),
                  
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
          ),
        );
      },
    );
  }

  Widget _buildModalDetailRow(String label, String value, {Color valueColor = AppColors.gray700}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 14, color: valueColor)),
      ],
    );
  }
}
