import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/medical_result.dart';
import '../data/models/reminder.dart';
import '../data/repositories/patient_support_repository.dart';
import '../../../../core/network/dio_client.dart';

final patientSupportRepositoryProvider = Provider<PatientSupportRepository>((ref) {
  final dio = ref.read(dioProvider);
  return PatientSupportRepository(dio);
});

final medicalResultsProvider = FutureProvider<List<MedicalResult>>((ref) async {
  final repo = ref.read(patientSupportRepositoryProvider);
  return repo.getMedicalResults();
});

final remindersProvider = StateNotifierProvider<RemindersNotifier, AsyncValue<List<Reminder>>>((ref) {
  final repo = ref.read(patientSupportRepositoryProvider);
  return RemindersNotifier(repo);
});

class RemindersNotifier extends StateNotifier<AsyncValue<List<Reminder>>> {
  final PatientSupportRepository _repository;

  RemindersNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadReminders();
  }

  Future<void> loadReminders() async {
    try {
      state = const AsyncValue.loading();
      final reminders = await _repository.getReminders();
      state = AsyncValue.data(reminders);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _repository.markReminderAsRead(id);
      state = state.whenData((reminders) {
        return reminders.map((r) {
          if (r.id == id) {
            return Reminder(
              id: r.id,
              title: r.title,
              message: r.message,
              dateTime: r.dateTime,
              type: r.type,
              isRead: true,
            );
          }
          return r;
        }).toList();
      });
    } catch (e) {
      // Ignore error for now
    }
  }
}

final unreadReminderCountProvider = FutureProvider<int>((ref) async {
  final repo = ref.read(patientSupportRepositoryProvider);
  return repo.getUnreadReminderCount();
});
