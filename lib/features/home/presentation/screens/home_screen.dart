import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import '../widgets/quick_access_item.dart';
import '../widgets/agenda_card.dart';
import '../widgets/assistant_card.dart';
import '../widgets/hospital_card.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/presentation/providers/service_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),
            _buildMainMenu(context, ref),
            const SizedBox(height: 32),
            _buildSectionTitle('Agenda Terdaftar'),
            const AgendaCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Hermina Asisten Kesehatan Digital'),
            const AssistantCard(),
            const SizedBox(height: 24),
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
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 230,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: 0,
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset('assets/header_logo.png', width: 220),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 70, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat Pagi, Bang Rico',
                                style: TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Semoga harimu menyenangkan, salam sehat',
                                style: TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -25,
          left: 24,
          right: 24,
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(27),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Cari dokter atau Informasi',
                hintStyle: TextStyle(
                  color: AppColors.textLightGrey,
                  fontSize: 14,
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.textLightGrey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
      ],
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
          const QuickAccessItem(
            icon: Icons.card_giftcard_outlined,
            label: 'Penawaran\nKhusus',
            iconColor: AppColors.primary,
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

          return _buildGrid(displayedItems);
        } else {
          return _buildGrid(menuItems);
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildGrid(List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 8,
        childAspectRatio: 0.75,
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
                mainAxisSpacing: 16,
                crossAxisSpacing: 8,
                childAspectRatio: 0.75,
                children: items,
              ),
            ],
          ),
        );
      },
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
