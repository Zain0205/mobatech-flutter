import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../providers/appointment_provider.dart';
import 'package:intl/intl.dart';
import 'appointment_detail_screen.dart';

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
        loading: () => const CardSkeletonLoader(count: 4),
        error: (e, stack) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.textWhite),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
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
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -20,
              top: -10,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset('assets/header_logo.png', width: 220),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AppointmentDetailScreen(appointment: appointment),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Section: Date & Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundScreen.withOpacity(0.5),
                  border: const Border(bottom: BorderSide(color: AppColors.backgroundScreen)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          '${appointment.schedule?.date != null ? DateFormat('dd MMM yyyy').format(appointment.schedule!.date!) : '-'} • ${appointment.schedule?.startTime ?? ''}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                      ],
                    ),
                    _buildGlassStatusChip(appointment.status),
                  ],
                ),
              ),

              // 2. Middle Section: Doctor Info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
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
                            style: const TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appointment.doctor?.specialization ?? '-',
                            style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.notes, size: 14, color: AppColors.textGrey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    appointment.notes!,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Bottom Section: Action
              if (appointment.status == 'pending' || appointment.status == 'approved')
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _handleCancel(context, ref, appointment.id),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.errorRed,
                        side: BorderSide(color: AppColors.errorRed.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Batalkan Janji Temu', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
            ],
          ),
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: baseColor.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              label,
              style: TextStyle(color: baseColor, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        ),
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
