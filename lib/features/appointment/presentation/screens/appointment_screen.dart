import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../widgets/doctor_card.dart';
import '../../providers/appointment_provider.dart';
import 'doctor_detail_screen.dart';
import '../widgets/appointment_sliver_header.dart';

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
    _searchController = TextEditingController(
      text: ref.read(searchQueryProvider),
    );
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
            AppointmentSliverHeader(
              searchController: _searchController,
              selectedSpecialization: selectedSpecialization,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: doctorsAsync.when(
                data: (doctors) {
                  if (doctors.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          'Tidak ada dokter tersedia',
                          style: TextStyle(color: AppColors.textGrey),
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final doctor = doctors[index];
                      return DoctorCard(
                        doctor: doctor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DoctorDetailScreen(doctorId: doctor.id),
                            ),
                          );
                        },
                      );
                    }, childCount: doctors.length),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: CardSkeletonLoader(count: 4),
                ),
                error: (err, stack) => SliverToBoxAdapter(
                  child: Center(child: Text(ErrorHandler.getMessage(err))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
