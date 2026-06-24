import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlassStatusChip extends StatelessWidget {
  final String status;
  final double fontSize;

  const GlassStatusChip({super.key, required this.status, this.fontSize = 13});

  @override
  Widget build(BuildContext context) {
    Color baseColor;
    String label;

    switch (status.toLowerCase()) {
      case 'pending':
        baseColor = AppColors.iconOrange;
        label = 'Menunggu';
        break;
      case 'approved':
        baseColor = AppColors.iconBlue;
        label = 'Disetujui';
        break;
      case 'completed':
        baseColor = AppColors.primary;
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: baseColor.withValues(alpha: 0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                color: baseColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
