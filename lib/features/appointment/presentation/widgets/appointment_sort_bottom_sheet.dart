import '../../../../core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/appointment_provider.dart';

class AppointmentSortBottomSheet extends ConsumerWidget {
  const AppointmentSortBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (context) => const AppointmentSortBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: AppColors.backgroundScreen,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Urutkan Dokter',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(AppStrings.extAbjadaz),
              trailing:
                  ref.watch(doctorSortProvider) == DoctorSortOption.nameAsc
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(doctorSortProvider.notifier).state =
                    DoctorSortOption.nameAsc;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(AppStrings.extAbjadza),
              trailing:
                  ref.watch(doctorSortProvider) == DoctorSortOption.nameDesc
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(doctorSortProvider.notifier).state =
                    DoctorSortOption.nameDesc;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
