class PolyclinicSchedule {
  final int id;
  final int polyclinicId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isAvailable;

  PolyclinicSchedule({
    required this.id,
    required this.polyclinicId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  factory PolyclinicSchedule.fromJson(Map<String, dynamic> json) {
    return PolyclinicSchedule(
      id: json['ID'] ?? 0,
      polyclinicId: json['polyclinic_id'] ?? 0,
      dayOfWeek: json['day_of_week'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      isAvailable: json['is_available'] ?? false,
    );
  }
}

class Polyclinic {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final bool isActive;
  final List<PolyclinicSchedule> schedules;

  Polyclinic({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.isActive,
    required this.schedules,
  });

  factory Polyclinic.fromJson(Map<String, dynamic> json) {
    var list = json['schedules'] as List? ?? [];
    List<PolyclinicSchedule> schedulesList = list
        .map((i) => PolyclinicSchedule.fromJson(i))
        .toList();

    return Polyclinic(
      id: json['ID'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      isActive: json['is_active'] ?? false,
      schedules: schedulesList,
    );
  }
}
