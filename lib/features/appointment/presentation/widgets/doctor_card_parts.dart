import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DoctorStatusBadge extends StatelessWidget {
  final bool isActive;

  const DoctorStatusBadge({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Available',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.errorRed.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Unavailable',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.errorRed,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}
