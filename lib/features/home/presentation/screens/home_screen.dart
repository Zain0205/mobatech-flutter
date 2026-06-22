import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import '../widgets/quick_access_item.dart';
import '../widgets/agenda_card.dart';
import '../widgets/assistant_card.dart';
import '../widgets/hospital_card.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../services/presentation/providers/service_provider.dart';
import '../../../appointment/providers/appointment_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../patient_support/providers/patient_support_provider.dart';
import 'search_screen.dart';

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
                  _buildHeader(context, ref),
                  const SizedBox(height: 24),
                  _buildMainMenu(context, ref),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Agenda Terdaftar'),
                  _buildAgendaList(ref),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Hermina Asisten Kesehatan Digital'),
                  const AssistantCard(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('RS Hermina terdekat dari rumah kamu'),
                  const HospitalCard(
                    name: 'Hermina Ciledug',
                    address: 'Jl. Cipto Mangunkusumo No 12 Kab...',
                    distance: '6 KM',
                  ),
                  const HospitalCard(
                    name: 'Hermina Cibinong',
                    address: 'Jl. Raya Jakarta-Bogor Km 46...',
                    distance: '6 KM',
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

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider).value;
    final firstName = userProfile?.fullName.split(' ').first ?? 'Pengguna';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
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
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      backgroundImage: userProfile?.imagePath != null ? (userProfile!.imagePath!.startsWith('http') ? NetworkImage(userProfile.imagePath!) as ImageProvider : FileImage(File(userProfile.imagePath!))) : null,
                      child: userProfile?.imagePath == null ? const Icon(Icons.person, color: AppColors.textWhite, size: 28) : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Pagi, $firstName',
                            style: const TextStyle(
                              color: AppColors.textWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Semoga harimu menyenangkan, salam sehat',
                            style: TextStyle(
                              color: AppColors.textWhite,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final unreadCountAsync = ref.watch(unreadReminderCountProvider);
                        return Stack(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications_outlined, color: AppColors.textWhite, size: 28),
                              onPressed: () => context.push('/notifications'),
                            ),
                            if (unreadCountAsync.value != null && unreadCountAsync.value! > 0)
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.errorRed,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    unreadCountAsync.value!.toString(),
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
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
                              onSubmitted: (value) {
                                if (value.trim().isNotEmpty) {
                                  ref.read(globalSearchQueryProvider.notifier).state = value;
                                  context.push('/search');
                                }
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Cari layanan atau spesialis...',
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                                prefixIcon: Icon(Icons.search, color: Colors.white, size: 20),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.overlayWhite20,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.backgroundWhite, width: 1.5),
      ),
      child: Icon(icon, color: AppColors.textWhite, size: 20),
    );
  }

  Widget _buildMainMenu(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return servicesAsync.when(
      data: (services) {
        final List<Widget> menuItems = [
          QuickAccessItem(
            icon: Icons.calendar_month_outlined,
            label: 'Buat Janji\nTemu',
            iconColor: AppColors.primary,
            onTap: () => context.push('/appointment'),
          ),
          QuickAccessItem(
            icon: Icons.card_giftcard_outlined,
            label: 'Penawaran\nKhusus',
            iconColor: AppColors.primary,
            onTap: () => context.push('/special-offers'),
          ),
          QuickAccessItem(
            icon: Icons.smart_toy_outlined,
            label: 'Hermina\nAssistant',
            iconColor: AppColors.primary,
            onTap: () => context.push('/chatbot'),
          ),
          QuickAccessItem(
            icon: Icons.emergency_outlined,
            label: 'Panggilan\nEmergensi',
            iconColor: AppColors.errorRed,
            onTap: () => context.push('/emergency'),
          ),
        ];

        for (var service in services) {
          menuItems.add(
            QuickAccessItem(
              icon: _getIconData(service['icon']),
              label: service['name'] ?? '',
              iconColor: AppColors.primary,
              onTap: () {
                if (service['name'] == 'IGD 24 Jam') {
                  context.push('/emergency');
                } else if (service['name'] == 'Farmasi' ||
                    service['name'] == 'Layanan Farmasi') {
                  context.push('/pharmacy');
                }
              },
            ),
          );
        }

        if (menuItems.length > 8) {
          final List<Widget> displayedItems = menuItems.sublist(0, 7);
          final List<Widget> remainingItems = menuItems.sublist(7);

          displayedItems.add(
            QuickAccessItem(
              icon: Icons.grid_view,
              label: 'Lainnya',
              iconColor: AppColors.primary,
              onTap: () {
                _showMoreMenu(context, remainingItems);
              },
            ),
          );

          return _buildGrid(context, displayedItems);
        } else {
          return _buildGrid(context, menuItems);
        }
      },
      loading: () => const GridSkeletonLoader(count: 8),
      error: (err, stack) => Center(child: Text(ErrorHandler.getMessage(err))),
    );
  }

  Widget _buildGrid(BuildContext context, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 8,
        childAspectRatio: MediaQuery.of(context).size.width / 4 / 115,
        children: items,
      ),
    );
  }

  void _showMoreMenu(BuildContext context, List<Widget> items) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Menu Lainnya',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 8,
                childAspectRatio: MediaQuery.of(context).size.width / 4 / 115,
                children: items,
              ),
            ],
          ),
        );
      },
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
                'Belum ada agenda terdaftar',
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
          );
        }
        
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: appointments.length > 2 ? 2 : appointments.length, // Show max 2 on home
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

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'local_hospital':
        return Icons.local_hospital_outlined;
      case 'medical_services':
        return Icons.medical_services_outlined;
      case 'biotech':
        return Icons.biotech_outlined;
      case 'bed':
        return Icons.bed_outlined;
      default:
        return Icons.healing_outlined;
    }
  }
}
