import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/appointment_provider.dart';
import 'package:intl/intl.dart';

class UserAppointmentsScreen extends ConsumerWidget {
  const UserAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(userAppointmentsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      body: appointmentsAsync.when(
        data: (appointments) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(userAppointmentsProvider);
            },
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(context),
                if (appointments.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy, size: 64, color: AppColors.textLightGrey),
                          const SizedBox(height: 16),
                          const Text('Belum ada janji temu.', style: TextStyle(fontSize: 16, color: AppColors.textGrey)),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final appointment = appointments[index];
                          return _buildAppointmentCard(context, ref, appointment);
                        },
                        childCount: appointments.length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Janji Temu Saya',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        background: Stack(
          children: [
            Positioned(
              right: -30,
              top: -10,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset('assets/header_logo.png', width: 200),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, WidgetRef ref, dynamic appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
      child: appointment.doctor?.imageUrl != null && appointment.doctor!.imageUrl.isNotEmpty
          ? Image.network(
              appointment.doctor!.imageUrl.replaceAll('/svg', '/png').replaceAll('.svg', '.png'), 
              width: 60, 
              height: 60, 
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Container(
                width: 60, height: 60, color: AppColors.primaryLight, child: const Icon(Icons.person, color: AppColors.primary),
              ),
            )
          : Container(
                          width: 60,
                          height: 60,
                          color: AppColors.primaryLight,
                          child: const Icon(Icons.person, color: AppColors.primary),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctor?.name ?? 'Dokter Tidak Diketahui',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.doctor?.specialization ?? '-',
                        style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.borderGrey),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_month, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  appointment.schedule?.date != null ? DateFormat('dd MMM yyyy').format(appointment.schedule!.date!) : '-',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
                const SizedBox(width: 24),
                const Icon(Icons.access_time, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  '${appointment.schedule?.startTime ?? ''} - ${appointment.schedule?.endTime ?? ''}',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundScreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.note_alt_outlined, size: 20, color: AppColors.textGrey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appointment.notes ?? '-',
                      style: const TextStyle(color: AppColors.textDark, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusChip(appointment.status),
                if (appointment.status == 'pending' || appointment.status == 'approved')
                  TextButton(
                    onPressed: () => _handleCancel(context, ref, appointment.id),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.errorRed,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Batalkan', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status.toLowerCase()) {
      case 'pending':
        bgColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange.shade800;
        label = 'Menunggu';
        break;
      case 'approved':
        bgColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue.shade800;
        label = 'Disetujui';
        break;
      case 'completed':
        bgColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green.shade800;
        label = 'Selesai';
        break;
      case 'cancelled':
        bgColor = AppColors.errorRed.withValues(alpha: 0.1);
        textColor = AppColors.errorRed;
        label = 'Dibatalkan';
        break;
      default:
        bgColor = AppColors.backgroundScreen;
        textColor = AppColors.textGrey;
        label = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Future<void> _handleCancel(BuildContext context, WidgetRef ref, int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Janji Temu?'),
        content: const Text('Apakah Anda yakin ingin membatalkan janji temu ini?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Tidak')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed, foregroundColor: Colors.white),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final repo = ref.read(appointmentRepositoryProvider);
        await repo.cancelAppointment(id);
        ref.refresh(userAppointmentsProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Janji temu berhasil dibatalkan')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal membatalkan: $e')),
          );
        }
      }
    }
  }
}
