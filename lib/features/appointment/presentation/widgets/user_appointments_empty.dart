import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EmptyAppointments extends StatelessWidget {
  const EmptyAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: AppColors.textLightGrey),
          const SizedBox(height: 16),
          const Text(
            'Belum ada janji temu.',
            style: TextStyle(fontSize: 16, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
