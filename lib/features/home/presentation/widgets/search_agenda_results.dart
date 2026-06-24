import '../../../../core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../appointment/providers/appointment_provider.dart';
import 'search_widgets.dart';

class SearchAgendaResults extends ConsumerWidget {
  final String query;
  const SearchAgendaResults({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (query.isEmpty) {
      return const SearchEmptyState(
        msg: 'Cari jadwal kontrol / janji temu Anda...',
      );
    }

    final apptsAsync = ref.watch(userAppointmentsProvider);
    return apptsAsync.when(
      data: (appts) {
        final filtered = appts.where((a) {
          final docName = a.doctor?.name ?? '';
          final docSpec = a.doctor?.specialization ?? '';
          return docName.toLowerCase().contains(query) ||
              docSpec.toLowerCase().contains(query);
        }).toList();
        if (filtered.isEmpty) {
          return const SearchEmptyState(msg: 'Agenda tidak ditemukan');
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, i) {
            final docName = filtered[i].doctor?.name ?? 'Dokter';
            final docSpec = filtered[i].doctor?.specialization ?? 'Spesialis';
            return SearchItem(
              icon: Icons.calendar_today,
              title: 'Kontrol $docName',
              subtitle: docSpec,
              onTap: () => context.push('/appointment'),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text(AppStrings.extGagalmemuat)),
    );
  }
}
