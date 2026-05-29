class StageModel {
  final int id;
  final String title;
  String startDate;
  String endDate;
  final bool isActive;

  StageModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  // حالة المرحلة محسوبة من is_active والتواريخ
  String get status {
    if (isActive) return 'نشطة';
    final now = DateTime.now();
    try {
      final end = DateTime.parse(endDate);
      if (end.isBefore(now)) return 'منتهية';
    } catch (_) {}
    return 'قادمة';
  }

  factory StageModel.fromJson(Map<String, dynamic> json) {
    return StageModel(
      id: (json['stages_id'] as num).toInt(),
      title: json['stage_name'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      isActive: json['stage_isactive'] as bool? ?? false,
    );
  }
}
