import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../screens/appointment_detail_screen.dart';

class AppointmentCard extends StatelessWidget {
  final dynamic appointment;
  final VoidCallback onCancel;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onCancel,
  });

  Widget _buildGlassStatusChip(String status) {
    Color baseColor;
    String label;

    switch (status.toLowerCase()) {
      case 'pending':
        baseColor = Colors.orange;
        label = 'Menunggu';
        break;
      case 'approved':
        baseColor = Colors.blue;
        label = 'Disetujui';
        break;
      case 'completed':
        baseColor = Colors.green;
        label = 'Selesai';
        break;
      case 'cancelled':
        baseColor = AppColors.errorRed;
        label = 'Dibatalkan';
        break;
      default:
        baseColor = AppColors.textGrey;
        label = status.toUpperCase();
    }

    return Container(
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: baseColor.withValues(alpha: 0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              label,
              style: TextStyle(
                color: baseColor,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.white.withValues(alpha: 0.85),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AppointmentDetailScreen(appointment: appointment),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Top Section: Date & Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundScreen.withValues(
                          alpha: 0.5,
                        ),
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
                          _buildGlassStatusChip(appointment.status),
                        ],
                      ),
                    ),

                    // 2. Middle Section: Doctor Info
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child:
                                appointment.doctor?.imageUrl != null &&
                                    appointment.doctor!.imageUrl.isNotEmpty
                                ? Image.network(
                                    appointment.doctor!.imageUrl
                                        .replaceAll('/svg', '/png')
                                        .replaceAll('.svg', '.png'),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) =>
                                        Container(
                                          width: 60,
                                          height: 60,
                                          color: AppColors.primaryLight,
                                          child: const Icon(
                                            Icons.person,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                  )
                                : Container(
                                    width: 60,
                                    height: 60,
                                    color: AppColors.primaryLight,
                                    child: const Icon(
                                      Icons.person,
                                      color: AppColors.primary,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment.doctor?.name ??
                                      'Dokter Tidak Diketahui',
                                  style: const TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appointment.doctor?.specialization ?? '-',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (appointment.notes != null &&
                                    appointment.notes!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.notes,
                                        size: 14,
                                        color: AppColors.textGrey,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          appointment.notes!,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textGrey,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 3. Bottom Section: Action
                    if (appointment.status == 'pending' ||
                        appointment.status == 'approved')
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: onCancel,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.errorRed,
                              side: BorderSide(
                                color: AppColors.errorRed.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Batalkan Janji Temu',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
