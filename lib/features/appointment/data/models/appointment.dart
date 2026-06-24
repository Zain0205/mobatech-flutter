import 'doctor.dart';
import 'doctor_schedule.dart';

class Appointment {
  final int id;
  final int userId;
  final int doctorId;
  final int doctorScheduleId;
  final String status;
  final String notes;
  final Doctor? doctor;
  final DoctorSchedule? schedule;

  Appointment({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.doctorScheduleId,
    required this.status,
    required this.notes,
    this.doctor,
    this.schedule,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['ID'] ?? 0,
      userId: json['user_id'] ?? 0,
      doctorId: json['doctor_id'] ?? 0,
      doctorScheduleId: json['doctor_schedule_id'] ?? 0,
      status: json['status'] ?? '',
      notes: json['notes'] ?? '',
      doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null,
      schedule: json['schedule'] != null
          ? DoctorSchedule.fromJson(json['schedule'])
          : null,
    );
  }
}
