import 'package:dio/dio.dart';
import '../models/medical_result.dart';
import '../models/reminder.dart';

class PatientSupportRepository {
  final Dio _dio;

  PatientSupportRepository(this._dio);
  Future<List<MedicalResult>> getMedicalResults() async {
    try {
      final response = await _dio.get('/medical-results');
      if (response.data != null) {
        return (response.data as List)
            .map((e) => MedicalResult.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      // Fallback dummy data
      return [
        MedicalResult(
          id: '1',
          testName: 'Cek Darah Lengkap',
          date: '2023-10-15',
          status: 'Selesai',
          hospitalName: 'RS Hermina Ciledug',
          doctorName: 'Dr. Andi Pratama',
          resultDetails: 'Hemoglobin: 14.5 g/dL\nLeukosit: 6500 /uL',
        ),
        MedicalResult(
          id: '2',
          testName: 'Rontgen Thorax',
          date: '2023-11-20',
          status: 'Menunggu Hasil',
          hospitalName: 'RS Hermina Cibinong',
        ),
      ];
    }
  }

  Future<List<Reminder>> getReminders() async {
    try {
      final response = await _dio.get('/reminders');
      if (response.data != null) {
        return (response.data as List)
            .map((e) => Reminder.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      // Fallback dummy data
      return [
        Reminder(
          id: '1',
          title: 'Waktu Minum Obat',
          message: 'Jangan lupa minum obat Paracetamol 500mg setelah makan.',
          dateTime: '2023-12-01 08:00:00',
          type: 'medication',
          isRead: false,
        ),
        Reminder(
          id: '2',
          title: 'Jadwal Kontrol',
          message: 'Besok jadwal kontrol dengan Dr. Andi Pratama jam 10:00.',
          dateTime: '2023-12-02 10:00:00',
          type: 'appointment',
          isRead: true,
        ),
      ];
    }
  }

  Future<void> markReminderAsRead(String id) async {
    try {
      await _dio.put('/reminders/$id/read', data: {});
    } catch (e) {
      // Silently fail for dummy mode
    }
  }

  Future<int> getUnreadReminderCount() async {
    try {
      final response = await _dio.get('/reminders/unread-count');
      return response.data['count'] ?? 0;
    } catch (e) {
      return 1; // Dummy value
    }
  }
}
