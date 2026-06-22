import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../appointment/providers/appointment_provider.dart';
import 'search_widgets.dart';

class SearchDoctorResults extends ConsumerWidget {
  final String query;
  const SearchDoctorResults({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (query.isEmpty) return const SearchEmptyState(msg: 'Cari nama atau spesialisasi dokter...');
    
    final doctorsAsync = ref.watch(doctorsProvider);
    return doctorsAsync.when(
      data: (doctors) {
        final filtered = doctors.where((d) => 
          d.name.toLowerCase().contains(query) || d.specialization.toLowerCase().contains(query)
        ).toList();
        if (filtered.isEmpty) return const SearchEmptyState(msg: 'Dokter tidak ditemukan');
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, i) => SearchItem(icon: Icons.person, title: filtered[i].name, subtitle: filtered[i].specialization, onTap: () => context.push('/appointment')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Gagal memuat')),
    );
  }
}
