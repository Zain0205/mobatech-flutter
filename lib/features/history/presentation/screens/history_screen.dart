import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import '../widgets/appointments_tab.dart';
import '../widgets/pharmacy_tab.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundScreen,
        appBar: AppBar(
          title: const Text(AppStrings.historyTitle, style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textWhite),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          flexibleSpace: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset('assets/header_logo.png', width: 220),
                  ),
                ),
              ],
            ),
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.textWhite,
            labelColor: AppColors.textWhite,
            unselectedLabelColor: AppColors.textWhite70,
            tabs: [
              Tab(text: AppStrings.appointmentTab),
              Tab(text: AppStrings.pharmacyTab),
            ],
          ),
        ),
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
          child: const TabBarView(
            children: [
              AppointmentsTab(),
              PharmacyTab(),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
      ),
    );
  }
}
