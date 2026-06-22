import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../providers/appointment_provider.dart';
import '../widgets/appointment_card.dart';
import '../widgets/user_appointments_app_bar.dart';

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
              final _ = ref.refresh(userAppointmentsProvider);
            },
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: CustomScrollView(
                    slivers: [
                      const UserAppointmentsAppBar(),
                      if (appointments.isEmpty)
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 64,
                                  color: AppColors.textLightGrey,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Belum ada janji temu.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.all(24),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final appointment = appointments[index];
                              return AppointmentCard(
                                appointment: appointment,
                                onCancel: () =>
                                    _handleCancel(context, ref, appointment.id),
                              );
                            }, childCount: appointments.length),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const CardSkeletonLoader(count: 4),
        error: (e, stack) => Center(child: Text(ErrorHandler.getMessage(e))),
      ),
    );
  }

  Future<void> _handleCancel(
    BuildContext context,
    WidgetRef ref,
    int id,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Janji Temu?'),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan janji temu ini?',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final repo = ref.read(appointmentRepositoryProvider);
        await repo.cancelAppointment(id);
        final _ = ref.refresh(userAppointmentsProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Janji temu berhasil dibatalkan')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ErrorHandler.getMessage(e),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}
