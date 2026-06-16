import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
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
      body: TweenAnimationBuilder<double>(
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverHeader(context, ref, selectedSpecialization),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: doctorsAsync.when(
                data: (doctors) {
                  if (doctors.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(child: Text('Tidak ada dokter tersedia', style: TextStyle(color: AppColors.textGrey))),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final doctor = doctors[index];
                        return DoctorCard(
                          doctor: doctor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DoctorDetailScreen(doctorId: doctor.id)),
                            );
                          },
                        );
                      },
                      childCount: doctors.length,
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: CardSkeletonLoader(count: 4),
                ),
                error: (err, stack) => SliverToBoxAdapter(child: Center(child: Text(ErrorHandler.getMessage(err)))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context, WidgetRef ref, String selectedSpecialization) {
    return SliverAppBar(
      backgroundColor: AppColors.primary,
      expandedHeight: 260,
      pinned: true,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textWhite, size: 20),
      ),
      title: const Text(
        'Janji Temu Dokter',
        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite, fontSize: 18),
      ),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PolyclinicScreen())),
          child: const Icon(Icons.domain, color: AppColors.textWhite, size: 24),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => context.push('/appointment/user-appointments'),
          child: const Icon(Icons.calendar_month, color: AppColors.textWhite, size: 24),
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
                    // Filter Chips
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
              ),
            ],
          ),
        ),
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
         ),
        );
      },
    );
  }
}
