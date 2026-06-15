import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../widgets/doctor_card.dart';
import '../widgets/appointment_filter_chip.dart';
import '../../providers/appointment_provider.dart';
import 'doctor_detail_screen.dart';
import 'polyclinic_screen.dart';

class AppointmentScreen extends ConsumerStatefulWidget {
  const AppointmentScreen({super.key});

  @override
  ConsumerState<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends ConsumerState<AppointmentScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(searchQueryProvider));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctorsAsync = ref.watch(filteredDoctorsProvider);
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return DoctorCard(
                      doctor: doctor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorDetailScreen(doctorId: doctor.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CardSkeletonLoader(count: 3),
              ),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, String selectedSpecialization) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 24),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. App Bar Area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textWhite, size: 20),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Janji Temu Dokter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PolyclinicScreen()));
                      },
                      child: const Icon(Icons.domain, color: AppColors.textWhite, size: 24),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => context.push('/appointment/user-appointments'),
                      child: const Icon(Icons.calendar_month, color: AppColors.textWhite, size: 24),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // 2. Compact Search Bar Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Cari dokter atau spesialis...',
                            hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
                            prefixIcon: Icon(Icons.search, color: Colors.white, size: 20),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    _showSortBottomSheet(context, ref);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.tune, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Scrollable Filter Chips bleeding to edge
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Row(
              children: [
                _buildFilterChip(ref, selectedSpecialization, 'All', Icons.border_all),
                _buildFilterChip(ref, selectedSpecialization, 'Spesialis Anak', Icons.child_care),
                _buildFilterChip(ref, selectedSpecialization, 'Spesialis Gigi', Icons.medical_services_outlined),
                _buildFilterChip(ref, selectedSpecialization, 'Spesialis Penyakit Dalam', Icons.monitor_heart_outlined),
                _buildFilterChip(ref, selectedSpecialization, 'Spesialis Kulit & Kelamin', Icons.face),
                _buildFilterChip(ref, selectedSpecialization, 'Spesialis Kandungan', Icons.pregnant_woman),
              ],
            ),
          ),
        ],
      ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(WidgetRef ref, String selected, String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedSpecializationProvider.notifier).state = label;
      },
      child: AppointmentFilterChip(
        label: label,
        isSelected: selected == label,
        icon: icon,
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundScreen,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
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
                title: const Text('Abjad A-Z'),
                trailing: ref.watch(doctorSortProvider) == DoctorSortOption.nameAsc
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  ref.read(doctorSortProvider.notifier).state = DoctorSortOption.nameAsc;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Abjad Z-A'),
                trailing: ref.watch(doctorSortProvider) == DoctorSortOption.nameDesc
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  ref.read(doctorSortProvider.notifier).state = DoctorSortOption.nameDesc;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
