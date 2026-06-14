import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/student_model.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final List<Student> students = [
    Student(
      id: '1',
      name: 'أحمد محمد علي',
      email: 'ahmed@university.edu',
      phone: '+966501234567',
      specialization: 'هندسة البرمجيات',
      advisor: 'أ.د محمد السلام',
      status: 'active',
    ),
    Student(
      id: '2',
      name: 'فاطمة خالد إبراهيم',
      email: 'fatima@university.edu',
      phone: '+966501234568',
      specialization: 'قواعد البيانات',
      advisor: 'أ.د سارة محمود',
      status: 'active',
    ),
    Student(
      id: '3',
      name: 'محمود علي حسن',
      email: 'mahmoud@university.edu',
      phone: '+966501234569',
      specialization: 'الشبكات',
      advisor: 'أ.د علي أحمد',
      status: 'active',
    ),
  ];

  late List<Student> filteredStudents;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredStudents = students;
    _searchController.addListener(_filterStudents);
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredStudents = students
          .where((student) =>
              student.name.toLowerCase().contains(query) ||
              student.email.toLowerCase().contains(query) ||
              student.specialization.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلاب والمشرفين'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الطلاب والمشرفين',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'إدارة بيانات الطلاب والمشرفين الأكاديميين',
                        style: TextStyle(color: AppColors.gray600),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة طالب جديد'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'ابحث عن طالب...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Table
              Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('الاسم')),
                      DataColumn(label: Text('التخصص')),
                      DataColumn(label: Text('المشرف الأكاديمي')),
                      DataColumn(label: Text('البريد الإلكتروني')),
                      DataColumn(label: Text('الحالة')),
                      DataColumn(label: Text('الإجراءات')),
                    ],
                    rows: filteredStudents
                        .map(
                          (student) => DataRow(
                            cells: [
                              DataCell(Text(student.name)),
                              DataCell(Text(student.specialization)),
                              DataCell(Text(student.advisor)),
                              DataCell(Text(student.email)),
                              DataCell(
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
                                    'نشط',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {},
                                      iconSize: 18,
                                      color: AppColors.primary,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {},
                                      iconSize: 18,
                                      color: AppColors.error,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Stats
              GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'إجمالي الطلاب',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            filteredStudents.length.toString(),
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'الطلاب النشطين',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            filteredStudents
                                .where((s) => s.status == 'active')
                                .length
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(color: AppColors.success),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'التخصصات',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            filteredStudents
                                .map((s) => s.specialization)
                                .toSet()
                                .length
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
