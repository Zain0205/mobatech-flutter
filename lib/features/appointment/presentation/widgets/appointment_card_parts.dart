import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_status_chip.dart';

class AppointmentCardTopSection extends StatelessWidget {
  final dynamic appointment;

  const AppointmentCardTopSection({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundScreen.withValues(alpha: 0.5),
        border: const Border(
          bottom: BorderSide(color: AppColors.backgroundScreen),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '${appointment.schedule?.date != null ? DateFormat('dd MMM yyyy').format(appointment.schedule!.date!) : '-'} • ${appointment.schedule?.startTime ?? ''}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          GlassStatusChip(status: appointment.status, fontSize: 11),
        ],
      ),
    );
  }
}

class AppointmentCardBottomSection extends StatelessWidget {
  final dynamic appointment;
  final VoidCallback onCancel;

  const AppointmentCardBottomSection({
    super.key,
    required this.appointment,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (appointment.status != 'pending' && appointment.status != 'approved') {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onCancel,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.errorRed,
            side: BorderSide(color: AppColors.errorRed.withValues(alpha: 0.3)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            'Batalkan Janji Temu',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
