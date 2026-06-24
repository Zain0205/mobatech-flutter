import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/utils/error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/doctor_schedule.dart';
import 'schedules_card_widgets.dart';

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
            color: AppColors.backgroundWhite.withValues(alpha: 0.85),
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
                        return ScheduleItemCard(
                          schedule: schedule,
                          isSelected: isSelected,
                          onTap: () {
                            if (selectedScheduleId == schedule.id) {
                              onScheduleSelected(null);
                            } else {
                              onScheduleSelected(schedule.id);
                            }
                          },
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
