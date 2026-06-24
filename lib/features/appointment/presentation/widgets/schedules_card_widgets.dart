import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/doctor_schedule.dart';

class ScheduleItemCard extends StatelessWidget {
  final DoctorSchedule schedule;
  final bool isSelected;
  final VoidCallback? onTap;

  const ScheduleItemCard({
    super.key,
    required this.schedule,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable =
        schedule.isAvailable && (schedule.quota - schedule.booked > 0);
    final dateStr = schedule.date != null
        ? '${schedule.date!.day}/${schedule.date!.month}/${schedule.date!.year}'
        : '';

    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderGrey,
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
                color: isSelected ? AppColors.backgroundWhite : AppColors.textGrey,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Penuh',
                  style: TextStyle(
                    color: AppColors.errorRed,
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
                color: isSelected ? AppColors.primary : AppColors.textLightGrey,
              ),
          ],
        ),
      ),
    );
  }
}
