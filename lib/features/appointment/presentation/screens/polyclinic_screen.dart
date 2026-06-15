import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../providers/polyclinic_provider.dart';
import '../../providers/appointment_provider.dart';

class PolyclinicScreen extends ConsumerWidget {
  const PolyclinicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final polyclinicsAsync = ref.watch(polyclinicsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: AppBar(
        title: const Text('Jadwal Poli', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.textWhite),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset('assets/header_logo.png', width: 220),
                ),
              ),
            ],
          ),
        ),
      ),
      body: polyclinicsAsync.when(
        data: (polys) {
          if (polys.isEmpty) {
            return const Center(child: Text('Belum ada jadwal poli', style: TextStyle(color: AppColors.textDark)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            physics: const BouncingScrollPhysics(),
            itemCount: polys.length,
            itemBuilder: (context, index) {
              final poly = polys[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: AppColors.shadowColor.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      title: Text(poly.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(poly.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                      ),
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withOpacity(0.5),
                            border: const Border(top: BorderSide(color: AppColors.backgroundScreen)),
                          ),
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Jadwal Praktik:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 14)),
                                    const SizedBox(height: 12),
                                    if (poly.schedules.isEmpty)
                                      const Text('Jadwal belum tersedia', style: TextStyle(color: AppColors.textGrey, fontSize: 13))
                                    else
                                      ...poly.schedules.map((s) => Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                              child: const Icon(Icons.schedule, color: AppColors.primary, size: 16),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(s.dayOfWeek, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 13)),
                                            ),
                                            Text('${s.startTime} - ${s.endTime}', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 13)),
                                          ],
                                        ),
                                      )),
                                    
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          final spec = poly.name.replaceAll('Poli ', 'Spesialis ');
                                          ref.read(selectedSpecializationProvider.notifier).state = spec;
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.person_search, size: 18),
                                            SizedBox(width: 8),
                                            Text('Lihat Dokter di Poli Ini', style: TextStyle(fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const CardSkeletonLoader(count: 6),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
