class Stage {
  final String id;
  final String name;
  final String description;
  final String startDate;
  final String endDate;
  final String status; // active, completed, pending
  final int tasksCount;

  Stage({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.tasksCount,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      status: json['status'] as String,
      tasksCount: json['tasksCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'tasksCount': tasksCount,
    };
  }
}
