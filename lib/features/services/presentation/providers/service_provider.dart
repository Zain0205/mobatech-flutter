import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/service_repository.dart';

final serviceRepositoryProvider = Provider((ref) {
  return ServiceRepository(ref.watch(dioProvider));
});

final servicesProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(serviceRepositoryProvider);
  return await repo.getServices();
});
