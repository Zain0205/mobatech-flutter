import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../appointment/data/models/appointment.dart';

part 'agenda_card_components.dart';

class AgendaCard extends StatelessWidget {
  final Appointment appointment;
  const AgendaCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/appointment/user-appointments');
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12, left: 24, right: 24),
        decoration: _buildDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              children: [
                _DoctorInfo(appointment: appointment),
                _ScheduleInfo(appointment: appointment),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: AppColors.backgroundWhite.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowColor.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
