import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../screens/polyclinic_screen.dart';
import 'appointment_header_widgets.dart';

class AppointmentSliverHeader extends ConsumerWidget {
  final TextEditingController searchController;
  final String selectedSpecialization;

  const AppointmentSliverHeader({
    super.key,
    required this.searchController,
    required this.selectedSpecialization,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      backgroundColor: AppColors.primary,
      expandedHeight: 260,
      pinned: true,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.backgroundWhite),
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
                    AppointmentSearchBar(searchController: searchController),
                    const SizedBox(height: 20),
                    // Filter Chips
                    AppointmentFilterChips(
                      selectedSpecialization: selectedSpecialization,
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
