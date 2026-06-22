import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/appointment_provider.dart';
import '../screens/polyclinic_screen.dart';
import 'appointment_filter_chip.dart';
import 'appointment_sort_bottom_sheet.dart';

class AppointmentSliverHeader extends ConsumerWidget {
  final TextEditingController searchController;
  final String selectedSpecialization;

  const AppointmentSliverHeader({
    super.key,
    required this.searchController,
    required this.selectedSpecialization,
  });

  Widget _buildFilterChip(
    WidgetRef ref,
    String selected,
    String label,
    IconData icon,
  ) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      backgroundColor: AppColors.primary,
      expandedHeight: 260,
      pinned: true,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.textWhite,
          size: 20,
        ),
      ),
      title: const Text(
        'Janji Temu Dokter',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textWhite,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PolyclinicScreen()),
          ),
          child: const Icon(Icons.domain, color: AppColors.textWhite, size: 24),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => context.push('/appointment/user-appointments'),
          child: const Icon(
            Icons.calendar_month,
            color: AppColors.textWhite,
            size: 24,
          ),
        ),
        const SizedBox(width: 20),
      ],
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        child: FlexibleSpaceBar(
          background: Stack(
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
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search Bar
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
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: TextField(
                                    controller: searchController,
                                    onChanged: (value) =>
                                        ref
                                                .read(
                                                  searchQueryProvider.notifier,
                                                )
                                                .state =
                                            value,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText: 'Cari dokter atau spesialis...',
                                      hintStyle: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              AppointmentSortBottomSheet.show(context);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.tune,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      child: Row(
                        children: [
                          _buildFilterChip(
                            ref,
                            selectedSpecialization,
                            'All',
                            Icons.border_all,
                          ),
                          _buildFilterChip(
                            ref,
                            selectedSpecialization,
                            'Spesialis Anak',
                            Icons.child_care,
                          ),
                          _buildFilterChip(
                            ref,
                            selectedSpecialization,
                            'Spesialis Gigi',
                            Icons.medical_services_outlined,
                          ),
                          _buildFilterChip(
                            ref,
                            selectedSpecialization,
                            'Spesialis Penyakit Dalam',
                            Icons.monitor_heart_outlined,
                          ),
                          _buildFilterChip(
                            ref,
                            selectedSpecialization,
                            'Spesialis Kulit & Kelamin',
                            Icons.face,
                          ),
                          _buildFilterChip(
                            ref,
                            selectedSpecialization,
                            'Spesialis Kandungan',
                            Icons.pregnant_woman,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
