import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../data/repositories/polyclinic_repository.dart';
import '../data/models/polyclinic.dart';

final polyclinicRepositoryProvider = Provider((ref) {
  return PolyclinicRepository(ref.watch(dioProvider));
});

final polyclinicsProvider = FutureProvider<List<Polyclinic>>((ref) async {
  final repository = ref.watch(polyclinicRepositoryProvider);
  return repository.getPolyclinics();
});

final polyclinicDetailProvider = FutureProvider.family<Polyclinic, int>((
  ref,
  id,
) async {
  final repository = ref.watch(polyclinicRepositoryProvider);
  return repository.getPolyclinicById(id);
});
