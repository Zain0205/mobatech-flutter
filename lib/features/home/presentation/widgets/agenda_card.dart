import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../appointment/data/models/appointment.dart';

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
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.agendaHeader,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          appointment.doctor?.name ?? 'Nama Dokter',
                          style: const TextStyle(color: AppColors.textWhite, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderGrey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          appointment.doctor?.specialization ?? 'Spesialis',
                          style: const TextStyle(color: AppColors.textDark, fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: appointment.doctor?.imageUrl != null && !appointment.doctor!.imageUrl.contains('.svg')
                      ? Image.network(
                          appointment.doctor!.imageUrl, 
                          width: 60, height: 60, fit: BoxFit.cover, alignment: Alignment.topCenter,
                          errorBuilder: (context, error, stackTrace) => Image.asset('assets/doctor.png', width: 60, height: 60, fit: BoxFit.cover, alignment: Alignment.topCenter),
                        )
                      : Image.asset('assets/doctor.png', width: 60, height: 60, fit: BoxFit.cover, alignment: Alignment.topCenter),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.agendaBackground,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.schedule != null && appointment.schedule!.date != null
                    ? '${_getDayOfWeek(appointment.schedule!.date!)}, ${_formatDate(appointment.schedule!.date!)} . ${appointment.schedule!.startTime}'
                    : 'Jadwal belum ditentukan', 
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)
                ),
                const SizedBox(height: 4),
                Text('Status: ${appointment.status}', style: const TextStyle(fontSize: 13, color: AppColors.textDark)),
              ],
            ),
          )
        ],
      ),
        ),
      ),
      ),
    );
  }

  String _getDayOfWeek(DateTime date) {
    final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return days[date.weekday - 1];
  }

  String _formatDate(DateTime date) {
    // Simple format for now
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
