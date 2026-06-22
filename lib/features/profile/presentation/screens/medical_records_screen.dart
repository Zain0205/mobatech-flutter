import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../appointment/providers/appointment_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/medical_record_card.dart';
import '../widgets/medical_summary_card.dart';

class MedicalRecordsScreen extends ConsumerWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(userAppointmentsProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: AppBar(
        title: const Text('Data Rekam Medis', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              children: [
                profileAsync.when(
                  data: (user) => user != null ? MedicalSummaryCard(user: user, ref: ref) : const SizedBox(),
                  loading: () => const SkeletonLoader(width: double.infinity, height: 160, borderRadius: 24),
                  error: (e, s) => const SizedBox(),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Riwayat Pemeriksaan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                const SizedBox(height: 16),
                appointmentsAsync.when(
                  data: (appointments) {
                    if (appointments.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('Belum ada riwayat medis.', style: TextStyle(color: AppColors.textGrey)),
                        ),
                      );
                    }
                    final sorted = List.of(appointments)..sort((a, b) {
                      final dateA = a.schedule?.date ?? DateTime.now();
                      final dateB = b.schedule?.date ?? DateTime.now();
                      return dateB.compareTo(dateA);
                    });
                    return Column(
                      children: sorted.map((appt) {
                        final isDone = appt.status.toLowerCase() == 'completed';
                        final dateStr = appt.schedule?.date != null 
                            ? DateFormat('dd MMM yyyy').format(appt.schedule!.date ?? DateTime.now()) 
                            : '-';
                        final docSpec = appt.doctor?.specialization ?? 'Umum';
                        final docName = appt.doctor?.name ?? 'Dokter Tidak Diketahui';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: MedicalRecordCard(
                            date: dateStr,
                            type: 'Konsultasi $docSpec',
                            doctor: docName,
                            status: appt.status.toUpperCase(),
                            icon: Icons.medical_services_outlined,
                            color: isDone ? AppColors.primary : Colors.orange,
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Column(
                    children: [
                      SkeletonLoader(width: double.infinity, height: 100, borderRadius: 20),
                      SizedBox(height: 16),
                      SkeletonLoader(width: double.infinity, height: 100, borderRadius: 20),
                    ],
                  ),
                  error: (err, stack) => Center(child: Text(ErrorHandler.getMessage(err))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
