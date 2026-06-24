import '../../../../core/constants/app_strings.dart';
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

part 'medical_records_screen_parts.dart';

class MedicalRecordsScreen extends ConsumerWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(userAppointmentsProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: const _MedicalRecordsAppBar(),
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
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
                    ]),
                  ),
                ),
                _AppointmentsList(appointmentsAsync: appointmentsAsync),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
