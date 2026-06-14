class DoctorSchedule {
  final int id;
  final int doctorId;
  final DateTime? date;
  final String startTime;
  final String endTime;
  final int quota;
  final int booked;
  final bool isAvailable;

  DoctorSchedule({
    required this.id,
    required this.doctorId,
    this.date,
    required this.startTime,
    required this.endTime,
    required this.quota,
    required this.booked,
    required this.isAvailable,
  });

  factory DoctorSchedule.fromJson(Map<String, dynamic> json) {
    return DoctorSchedule(
      id: json['ID'] ?? 0,
      doctorId: json['doctor_id'] ?? 0,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      quota: json['quota'] ?? 0,
      booked: json['booked'] ?? 0,
      isAvailable: json['is_available'] ?? true,
    );
  }
}
