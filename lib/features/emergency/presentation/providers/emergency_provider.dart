import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/emergency_repository.dart';

final emergencyRepositoryProvider = Provider((ref) {
  return EmergencyRepository(ref.watch(dioProvider));
});

final emergencyHistoryProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(emergencyRepositoryProvider);
  return await repo.getHistory();
});
