import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/teams_controller.dart';
import '../model/team_model.dart';

class TeamsView extends StatelessWidget {
  const TeamsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Consumer<TeamsController>(
          builder: (context, controller, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'إدارة الفرق',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'عرض وإدارة فرق الطلاب وأبحاثهم',
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
                          _buildStatCard(
                            title: 'إجمالي الفرق',
                            value: controller.totalTeams.toString(),
                            bgColor: Colors.white,
                            textColor: const Color(0xFF2563EB),
                            borderColor: AppColors.gray200,
                            icon: Icons.people_outline,
                          ),
                          const SizedBox(height: 16),
                          _buildStatCard(
                            title: 'إجمالي الطلاب',
                            value: controller.totalStudents.toString(),
                            bgColor: const Color(0xFFEFF6FF),
                            textColor: const Color(0xFF2563EB),
                            borderColor: const Color(0xFFBFDBFE),
                            icon: null,
                          ),
                          const SizedBox(height: 16),
                          _buildStatCard(
                            title: 'متوسط حجم الفريق',
                            value: controller.averageTeamSize.toStringAsFixed(1),
                            bgColor: const Color(0xFFF0FDF4),
                            textColor: const Color(0xFF16A34A),
                            borderColor: const Color(0xFF86EFAC),
                            icon: null,
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'إجمالي الفرق',
                            value: controller.totalTeams.toString(),
                            bgColor: Colors.white,
                            textColor: const Color(0xFF2563EB),
                            borderColor: AppColors.gray200,
                            icon: Icons.people_outline,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'إجمالي الطلاب',
                            value: controller.totalStudents.toString(),
                            bgColor: const Color(0xFFEFF6FF),
                            textColor: const Color(0xFF2563EB),
                            borderColor: const Color(0xFFBFDBFE),
                            icon: null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'متوسط حجم الفريق',
                            value: controller.averageTeamSize.toStringAsFixed(1),
                            bgColor: const Color(0xFFF0FDF4),
                            textColor: const Color(0xFF16A34A),
                            borderColor: const Color(0xFF86EFAC),
                            icon: null,
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
                      hintText: 'البحث عن فريق أو طالب...',
                      hintStyle: TextStyle(color: AppColors.gray400),
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search, color: AppColors.gray400),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Teams Grid
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
                        childAspectRatio: isMobile ? 0.7 : 0.8,
                      ),
                      itemCount: controller.teams.length,
                      itemBuilder: (context, index) {
                        return _buildTeamCard(context, controller.teams[index]);
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
    IconData? icon,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null) Icon(icon, color: textColor, size: 24) else const SizedBox.shrink(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor == AppColors.foreground ? AppColors.gray600 : textColor,
                ),
              ),
            ],
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

  Widget _buildTeamCard(BuildContext context, TeamModel team) {
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
          // Header of Card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge "X أعضاء"
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${team.members.length} أعضاء',
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            team.projectTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.foreground,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBEAFE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.people_outline, color: Color(0xFF2563EB), size: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(right: 52), // Align under the text
                      child: Text(
                        team.department,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.gray500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: AppColors.gray200),
          ),
          
          // Content
          const Text('عنوان البحث:', style: TextStyle(fontSize: 13, color: AppColors.gray500)),
          const SizedBox(height: 4),
          Text(team.projectTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.foreground)),
          
          const SizedBox(height: 16),
          
          const Text('المشرف الأكاديمي:', style: TextStyle(fontSize: 13, color: AppColors.gray500)),
          const SizedBox(height: 4),
          Text(team.supervisor, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.foreground)),
          
          const SizedBox(height: 16),
          
          const Text('أعضاء الفريق:', style: TextStyle(fontSize: 13, color: AppColors.gray500)),
          const SizedBox(height: 8),
          
          // Members List
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: team.members.length,
              itemBuilder: (context, index) {
                final member = team.members[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: member.role == 'قائد الفريق' ? const Color(0xFFDBEAFE) : AppColors.gray100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          member.role,
                          style: TextStyle(
                            fontSize: 11,
                            color: member.role == 'قائد الفريق' ? const Color(0xFF2563EB) : AppColors.gray600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(member.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.foreground)),
                          Text(member.id, style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // View Full Details Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showDetailsModal(context, team);
              },
              icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
              label: const Text('عرض التفاصيل الكاملة', style: TextStyle(fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.foreground,
                side: const BorderSide(color: AppColors.gray300),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailsModal(BuildContext context, TeamModel team) {
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
                  // Modal Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            team.projectTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.foreground,
                            ),
                          ),
                          Text(
                            team.department,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.gray500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDBEAFE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.people_outline, color: Color(0xFF2563EB), size: 28),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Detail Container 1
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF), // Light Blue Background
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('عنوان البحث:', style: TextStyle(fontSize: 13, color: Color(0xFF2563EB))),
                        const SizedBox(height: 4),
                        Text(team.projectTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Detail Container 2
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4), // Light Green Background
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('المشرف الأكاديمي:', style: TextStyle(fontSize: 13, color: Color(0xFF16A34A))),
                        const SizedBox(height: 4),
                        Text(team.supervisor, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF14532D))),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Text('أعضاء الفريق (${team.members.length}):', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  
                  ...team.members.map((member) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.gray200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: member.role == 'قائد الفريق' ? const Color(0xFFDBEAFE) : AppColors.gray200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            member.role,
                            style: TextStyle(
                              fontSize: 12,
                              color: member.role == 'قائد الفريق' ? const Color(0xFF2563EB) : AppColors.gray700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(member.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.foreground)),
                            Text('الرقم الجامعي: ${member.id}', style: const TextStyle(fontSize: 13, color: AppColors.gray500)),
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
}
