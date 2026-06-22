import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/utils/error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/doctor_schedule.dart';

class SchedulesCard extends StatelessWidget {
  final AsyncValue<List<DoctorSchedule>> schedulesAsync;
  final int? selectedScheduleId;
  final ValueChanged<int?> onScheduleSelected;

  const SchedulesCard({
    super.key,
    required this.schedulesAsync,
    required this.selectedScheduleId,
    required this.onScheduleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.white.withValues(alpha: 0.85),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Jadwal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                schedulesAsync.when(
                  data: (schedules) {
                    if (schedules.isEmpty) {
                      return const Center(
                        child: Text(
                          'Tidak ada jadwal tersedia',
                          style: TextStyle(color: AppColors.textGrey),
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: schedules.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final schedule = schedules[index];
                        final isSelected = selectedScheduleId == schedule.id;
                        final isAvailable =
                            schedule.isAvailable &&
                            (schedule.quota - schedule.booked > 0);
                        final dateStr = schedule.date != null
                            ? '${schedule.date!.day}/${schedule.date!.month}/${schedule.date!.year}'
                            : '';

                        return GestureDetector(
                          onTap: isAvailable
                              ? () {
                                  if (selectedScheduleId == schedule.id) {
                                    onScheduleSelected(null);
                                  } else {
                                    onScheduleSelected(schedule.id);
                                  }
                                }
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.05)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.borderGrey,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.backgroundScreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textGrey,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$dateStr • ${schedule.startTime} - ${schedule.endTime}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isAvailable
                                              ? AppColors.textDark
                                              : AppColors.textGrey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Sisa kuota: ${schedule.quota - schedule.booked}',
                                        style: const TextStyle(
                                          color: AppColors.textGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!isAvailable)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Penuh',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                else
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textLightGrey,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const CardSkeletonLoader(count: 3),
                  error: (e, _) => Text(ErrorHandler.getMessage(e)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
