import 'package:dio/dio.dart';
import '../models/doctor.dart';
import '../models/doctor_schedule.dart';
import '../models/appointment.dart';

class AppointmentRepository {
  final Dio _dio;

  AppointmentRepository(this._dio);

  Future<List<Doctor>> getDoctors({String? specialization}) async {
    try {
      final response = await _dio.get(
        '/doctors',
        queryParameters: specialization != null && specialization.isNotEmpty && specialization != 'All'
            ? {'specialization': specialization}
            : null,
      );
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Doctor.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Doctor> getDoctorById(int id) async {
    try {
      final response = await _dio.get('/doctors/$id');
      return Doctor.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DoctorSchedule>> getDoctorSchedules(int id) async {
    try {
      final response = await _dio.get('/doctors/$id/schedules');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => DoctorSchedule.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Appointment>> getUserAppointments() async {
    try {
      final response = await _dio.get('/appointments');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Appointment.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Appointment> bookAppointment(int scheduleId, String symptoms) async {
    try {
      final response = await _dio.post('/appointments', data: {
        'doctor_schedule_id': scheduleId,
        'notes': symptoms,
      });
      return Appointment.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelAppointment(int id) async {
    try {
      await _dio.post('/appointments/$id/cancel');
    } catch (e) {
      rethrow;
    }
  }
}
