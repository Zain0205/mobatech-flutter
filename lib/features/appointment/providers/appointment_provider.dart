import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../data/repositories/appointment_repository.dart';
import '../data/models/doctor.dart';
import '../data/models/doctor_schedule.dart';
import '../data/models/appointment.dart';

final appointmentRepositoryProvider = Provider((ref) {
  return AppointmentRepository(ref.watch(dioProvider));
});

final selectedSpecializationProvider = StateProvider<String>((ref) => 'All');

final doctorsProvider = FutureProvider<List<Doctor>>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  final specialization = ref.watch(selectedSpecializationProvider);
  return repository.getDoctors(specialization: specialization);
});

final doctorDetailProvider = FutureProvider.family<Doctor, int>((ref, id) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getDoctorById(id);
});

final doctorSchedulesProvider = FutureProvider.family<List<DoctorSchedule>, int>((ref, doctorId) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getDoctorSchedules(doctorId);
});

final userAppointmentsProvider = FutureProvider<List<Appointment>>((ref) {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getUserAppointments();
});
