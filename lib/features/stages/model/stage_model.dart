class StageModel {
  final int id;
  final String title;
  String startDate;
  String endDate;

  StageModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
  });

  bool get isActive {
    if (startDate.isEmpty || endDate.isEmpty) return false;
    final now = DateTime.now();
    try {
      final start = DateTime.parse(startDate);
      // We add 1 day to end date so it includes the whole day
      final end = DateTime.parse(endDate).add(const Duration(days: 1));
      return now.isAfter(start) && now.isBefore(end);
    } catch (_) {
      return false;
    }
  }

  String get status {
    if (startDate.isEmpty || endDate.isEmpty) return 'غير محدد';
    final now = DateTime.now();
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate).add(const Duration(days: 1));
      
      if (now.isBefore(start)) return 'قادمة';
      if (now.isAfter(end)) return 'منتهية';
      return 'نشطة';
    } catch (_) {
      return 'غير محدد';
    }
  }

  factory StageModel.fromJson(Map<String, dynamic> json) {
    return StageModel(
      id: (json['stages_id'] as num).toInt(),
      title: json['stage_name'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
    );
  }
}
