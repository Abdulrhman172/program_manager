class StageModel {
  final String id;
  final String title;
  final String description;
  String startDate;
  String endDate;
  final String status; // 'نشطة', 'قادمة', 'منتهية'

  StageModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
}
