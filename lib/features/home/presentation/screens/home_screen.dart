import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/home_header.dart';
import '../widgets/quick_access_grid.dart';
import '../widgets/promo_banner_carousel.dart';
import '../widgets/assistant_card.dart';
import '../widgets/hospital_card.dart';
import '../widgets/agenda_card.dart';
import '../../../appointment/providers/appointment_provider.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/utils/error_handler.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeHeader(),
                  const SizedBox(height: 24),
                  const QuickAccessGrid(),
                  const SizedBox(height: 24),
                  const PromoBannerCarousel(),
                  const SizedBox(height: 20),
                  _buildSectionTitle(AppStrings.sectionAgenda),
                  _buildAgendaList(ref),
                  const SizedBox(height: 20),
                  _buildSectionTitle(AppStrings.sectionAssistant),
                  const AssistantCard(),
                  const SizedBox(height: 20),
                  _buildSectionTitle(AppStrings.sectionHospitals),
                  const HospitalCard(
                    name: AppStrings.hospital1Name,
                    address: AppStrings.hospital1Address,
                    distance: AppStrings.hospital1Distance,
                  ),
                  const HospitalCard(
                    name: AppStrings.hospital2Name,
                    address: AppStrings.hospital2Address,
                    distance: AppStrings.hospital2Distance,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildAgendaList(WidgetRef ref) {
    final appointmentsAsync = ref.watch(userAppointmentsProvider);
    
    return appointmentsAsync.when(
      data: (appointments) {
        if (appointments.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(
              child: Text(
                AppStrings.emptyAgenda,
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
          );
        }
        
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: appointments.length > 2 ? 2 : appointments.length,
          itemBuilder: (context, index) {
            return AgendaCard(appointment: appointments[index]);
          },
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: CardSkeletonLoader(count: 1),
      ),
      error: (err, stack) => Center(child: Text(ErrorHandler.getMessage(err))),
    );
  }
}
