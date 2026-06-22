import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../appointment/providers/appointment_provider.dart';
import 'history_card.dart';

class AppointmentsTab extends ConsumerWidget {
  const AppointmentsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(userAppointmentsProvider);
    return appointmentsAsync.when(
      data: (appointments) {
        if (appointments.isEmpty) return const Center(child: Text(AppStrings.noAppointmentHistory));
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appt = appointments[index];
            final title = '${AppStrings.appointmentWith} ${appt.doctor?.name ?? AppStrings.defaultDoctorName}';
            final status = appt.status.toUpperCase();
            final date = appt.schedule?.date != null ? DateFormat('dd MMM yyyy').format(appt.schedule!.date!) : '-';
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: HistoryCard(
                title: title, 
                status: status, 
                date: date, 
                onTap: () => context.push('/appointment/user-appointments')
              ),
            );
          },
        );
      },
      loading: () => const CardSkeletonLoader(count: 3),
      error: (e, stack) => _buildErrorState(ErrorHandler.getMessage(e)),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: AppColors.textLightGrey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
