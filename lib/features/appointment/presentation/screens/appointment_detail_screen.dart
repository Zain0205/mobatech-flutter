import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final dynamic appointment;

  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: AppBar(
        title: const Text('Detail Janji Temu', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.textWhite),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset('assets/header_logo.png', width: 220),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Status and QR Code section
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: AppColors.shadowColor.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                children: [
                  Text('ID Booking: #${appointment.id.toString().padLeft(6, '0')}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                  const SizedBox(height: 16),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundScreen,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderGrey, width: 2),
                    ),
                    child: const Icon(Icons.qr_code_2, size: 100, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  const Text('Tunjukkan QR Code ini di mesin antrean', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  const SizedBox(height: 16),
                  _buildGlassStatusChip(appointment.status),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Doctor Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: AppColors.shadowColor.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: appointment.doctor?.imageUrl != null && appointment.doctor!.imageUrl.isNotEmpty
                        ? Image.network(
                            appointment.doctor!.imageUrl.replaceAll('/svg', '/png').replaceAll('.svg', '.png'), 
                            width: 60, height: 60, fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(width: 60, height: 60, color: AppColors.primaryLight, child: const Icon(Icons.person, color: AppColors.primary)),
                          )
                        : Container(width: 60, height: 60, color: AppColors.primaryLight, child: const Icon(Icons.person, color: AppColors.primary)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appointment.doctor?.name ?? 'Dokter', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                          child: Text(appointment.doctor?.specialization ?? '-', style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Schedule Details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: AppColors.shadowColor.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Jadwal Konsultasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Text(appointment.schedule?.date != null ? DateFormat('EEEE, dd MMM yyyy').format(appointment.schedule!.date!) : '-', style: const TextStyle(color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Text('${appointment.schedule?.startTime ?? ''} - ${appointment.schedule?.endTime ?? ''}', style: const TextStyle(color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.note_alt_outlined, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(child: Text(appointment.notes ?? '-', style: const TextStyle(color: AppColors.textDark))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        color: baseColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: baseColor.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              label,
              style: TextStyle(color: baseColor, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}
