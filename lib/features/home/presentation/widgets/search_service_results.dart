import '../../../../core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../appointment/providers/polyclinic_provider.dart';
import 'search_widgets.dart';

class SearchServiceResults extends ConsumerWidget {
  final String query;
  const SearchServiceResults({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (query.isEmpty) {
      return const SearchEmptyState(
        msg: 'Cari layanan medis atau poliklinik...',
      );
    }

    final polyclinicsAsync = ref.watch(polyclinicsProvider);
    return polyclinicsAsync.when(
      data: (polys) {
        final filtered = polys
            .where(
              (p) =>
                  p.name.toLowerCase().contains(query) ||
                  p.description.toLowerCase().contains(query),
            )
            .toList();
        if (filtered.isEmpty) {
          return const SearchEmptyState(msg: 'Layanan tidak ditemukan');
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, i) => SearchItem(
            icon: Icons.local_hospital,
            title: filtered[i].name,
            subtitle: filtered[i].description,
            onTap: () => context.push('/appointment'),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text(AppStrings.extGagalmemuat)),
    );
  }
}
