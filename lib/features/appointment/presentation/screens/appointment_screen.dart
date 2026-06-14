import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/doctor_card.dart';
import '../widgets/appointment_filter_chip.dart';
import '../../providers/appointment_provider.dart';
import 'doctor_detail_screen.dart';

class AppointmentScreen extends ConsumerWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorsAsync = ref.watch(doctorsProvider);
    final selectedSpecialization = ref.watch(selectedSpecializationProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      body: Column(
        children: [
          _buildHeader(context, ref, selectedSpecialization),
          Expanded(
            child: doctorsAsync.when(
              data: (doctors) {
                if (doctors.isEmpty) {
                  return const Center(child: Text('Tidak ada dokter tersedia'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return DoctorCard(
                      doctor: doctor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoctorDetailScreen(doctorId: doctor.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, String selectedSpecialization) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset('assets/header_logo.png', width: 220),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Janji Temu Dokter',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => context.push('/appointment/user-appointments'),
                        child: const Icon(Icons.calendar_month, color: AppColors.textDark, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.transparent,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.textGrey),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: AppColors.textGrey, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Cari Dokter',
                                    hintStyle: TextStyle(fontSize: 14, color: AppColors.textGrey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.textGrey),
                        ),
                        child: const Icon(Icons.tune, color: AppColors.textDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(ref, selectedSpecialization, 'All'),
                        _buildFilterChip(ref, selectedSpecialization, 'Spesialis Anak'),
                        _buildFilterChip(ref, selectedSpecialization, 'Spesialis Gigi'),
                        _buildFilterChip(ref, selectedSpecialization, 'Spesialis Kulit & Kelamin'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(WidgetRef ref, String selected, String label) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedSpecializationProvider.notifier).state = label;
      },
      child: AppointmentFilterChip(
        label: label,
        isSelected: selected == label,
      ),
    );
  }
}
