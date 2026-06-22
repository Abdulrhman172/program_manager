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

                // Loading / Error
                if (controller.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (controller.errorMessage != null)
                  Center(
                    child: Text(
                      controller.errorMessage!,
                      style: const TextStyle(color: AppColors.error),
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
                          Row(
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
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
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
                    final w = constraints.maxWidth;
                    int cols = isMobile ? 1 : 2;
                    final spacing = 24.0;
                    final itemWidth = (w - (cols - 1) * spacing) / cols;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: List.generate(controller.teams.length, (index) {
                        return SizedBox(
                          width: itemWidth,
                          child: _buildTeamCard(context, controller.teams[index]),
                        );
                      }),
                    );
                  },
                ),
                ], // end of else
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
                            team.groupName,
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
                        team.programName,
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
          Text(team.groupName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.foreground)),
          
          const SizedBox(height: 16),
          
          const Text('المشرف الأكاديمي:', style: TextStyle(fontSize: 13, color: AppColors.gray500)),
          const SizedBox(height: 4),
          Text(team.supervisorName ?? 'غير محدد', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.foreground)),
          
          const SizedBox(height: 16),
          
          const Text('أعضاء الفريق:', style: TextStyle(fontSize: 13, color: AppColors.gray500)),
          const SizedBox(height: 8),
          
          // Members List
          ListView.builder(
            shrinkWrap: true,
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
                         Text(member.id.toString(), style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => EditTeamModal(team: team, controller: context.read<TeamsController>()),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('تعديل', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2563EB),
                    side: const BorderSide(color: Color(0xFF2563EB)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showDetailsModal(context, team);
                  },
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                  label: const Text('التفاصيل', style: TextStyle(fontWeight: FontWeight.bold)),
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
                            team.groupName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.foreground,
                            ),
                          ),
                          Text(
                        team.programName,
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
                        Text(team.groupName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
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
                        Text(team.supervisorName ?? 'غير محدد', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF14532D))),
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

class EditTeamModal extends StatefulWidget {
  final TeamModel team;
  final TeamsController controller;

  const EditTeamModal({super.key, required this.team, required this.controller});

  @override
  State<EditTeamModal> createState() => _EditTeamModalState();
}

class _EditTeamModalState extends State<EditTeamModal> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _supervisors = [];
  List<Map<String, dynamic>> _unassignedStudents = [];
  int? _selectedSupervisorId;
  int? _selectedStudentToAdd;

  @override
  void initState() {
    super.initState();
    _selectedSupervisorId = widget.team.supervisorId;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final sups = await widget.controller.fetchSupervisors();
    final studs = await widget.controller.fetchUnassignedStudents();
    setState(() {
      _supervisors = sups;
      _unassignedStudents = studs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(48.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [CircularProgressIndicator(), SizedBox(height: 16), Text('جاري تحميل البيانات...')],
          ),
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('تعديل الفريق: ${widget.team.groupName}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.foreground)),
              const SizedBox(height: 24),

              // Supervisor Section
              const Text('مشرف المجموعة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final success = await widget.controller.changeSupervisor(widget.team.groupId, _selectedSupervisorId);
                      if (!context.mounted) return;
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تغيير المشرف بنجاح'), backgroundColor: Colors.green));
                        widget.controller.fetchTeams();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.controller.errorMessage ?? 'حدث خطأ'), backgroundColor: Colors.red));
                      }
                    },
                    child: const Text('حفظ المشرف'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _selectedSupervisorId,
                      items: _supervisors.map((s) => DropdownMenuItem<int>(
                            value: s['sprvsr_id'],
                            child: Text(s['sprvsr_name']),
                          )).toList(),
                      onChanged: (val) {
                        setState(() => _selectedSupervisorId = val);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      hint: const Text('اختر مشرفاً'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Add Student Section
              const Text('إضافة طالب للمجموعة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _selectedStudentToAdd == null ? null : () async {
                      final success = await widget.controller.addStudent(_selectedStudentToAdd!, widget.team.groupId);
                      if (!context.mounted) return;
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت الإضافة بنجاح'), backgroundColor: Colors.green));
                        widget.controller.fetchTeams();
                        _loadData();
                        setState(() => _selectedStudentToAdd = null);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.controller.errorMessage ?? 'حدث خطأ'), backgroundColor: Colors.red));
                      }
                    },
                    child: const Text('إضافة للطالب'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _selectedStudentToAdd,
                      items: _unassignedStudents.map((s) => DropdownMenuItem<int>(
                            value: s['stud_id'],
                            child: Text('${s['stud_name']} (${s['stud_college_num']})'),
                          )).toList(),
                      onChanged: (val) {
                        setState(() => _selectedStudentToAdd = val);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      hint: const Text('اختر طالباً غير مرتبط بمجموعة'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Members List Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('عدد الأعضاء: ${widget.team.members.length}', style: const TextStyle(color: AppColors.gray600)),
                  const Text('أعضاء الفريق الحاليين', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 12),
              ...widget.team.members.map((member) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.gray200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              tooltip: 'حذف من المجموعة',
                              onPressed: () async {
                                final success = await widget.controller.removeStudent(member.id, widget.team.leaderId);
                                if (!context.mounted) return;
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحذف بنجاح'), backgroundColor: Colors.green));
                                  widget.controller.fetchTeams();
                                  _loadData();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.controller.errorMessage ?? 'حدث خطأ'), backgroundColor: Colors.red));
                                }
                              },
                            ),
                            if (member.id != widget.team.leaderId)
                              IconButton(
                                icon: const Icon(Icons.star_border, color: Colors.orange),
                                tooltip: 'تعيين كقائد',
                                onPressed: () async {
                                  final success = await widget.controller.assignNewLeader(widget.team.groupId, member.id);
                                  if (!context.mounted) return;
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم التعيين بنجاح'), backgroundColor: Colors.green));
                                    widget.controller.fetchTeams();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.controller.errorMessage ?? 'حدث خطأ'), backgroundColor: Colors.red));
                                  }
                                },
                              ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                if (member.id == widget.team.leaderId)
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(4)),
                                    child: const Text('قائد', style: TextStyle(fontSize: 10, color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                                  ),
                                Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                            Text('الرقم: ${member.id}', style: const TextStyle(fontSize: 12, color: AppColors.gray600)),
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
  }
}
