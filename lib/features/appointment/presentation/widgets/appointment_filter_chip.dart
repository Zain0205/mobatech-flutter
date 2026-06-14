import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AppointmentFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const AppointmentFilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.textGrey),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.textWhite : AppColors.textGrey,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }
}
