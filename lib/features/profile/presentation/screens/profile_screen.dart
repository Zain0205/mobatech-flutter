import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/utils/formatters.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      body: profileAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Data profil tidak ditemukan. Silakan login ulang.'));
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: const Text('Profil Saya', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 18)),
                  background: ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
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
                        // Add some gradient overlay for premium feel
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.primary.withOpacity(0.4),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
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
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildProfileCard(user),
                        const SizedBox(height: 32),
                        _buildMenuSection(context, ref),
                        const SizedBox(height: 32), // bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
         ),
        );
        },
        loading: () => _buildLoadingSkeleton(),
        error: (err, stack) => Center(child: Text(ErrorHandler.getMessage(err))),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
        SliverAppBar(
          expandedHeight: 120.0,
          pinned: true,
          backgroundColor: AppColors.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SkeletonLoader(width: double.infinity, height: 140, borderRadius: 24),
                const SizedBox(height: 32),
                SkeletonLoader(width: double.infinity, height: 360, borderRadius: 24),
              ],
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(UserProfile user) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary,
                  backgroundImage: user.imagePath != null ? (user.imagePath!.startsWith('http') ? NetworkImage(user.imagePath!) as ImageProvider : FileImage(File(user.imagePath!))) : null,
                  child: user.imagePath == null
                      ? Text(
                          user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                          style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Formatters.formatPhoneNumber(user.phone),
                        style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref) {
    final menuItems = [
      {'icon': Icons.person_outline, 'title': 'Ubah Profil'},
      {'icon': Icons.medical_information_outlined, 'title': 'Data Rekam Medis'},
      {'icon': Icons.family_restroom, 'title': 'Anggota Keluarga'},
      {'icon': Icons.settings_outlined, 'title': 'Pengaturan'},
      {'icon': Icons.help_outline, 'title': 'Bantuan & Dukungan'},
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.white.withOpacity(0.85),
            child: Column(
              children: [
                ...menuItems.map((item) => ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                        child: Icon(item['icon'] as IconData, color: AppColors.primary),
                      ),
                      title: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                      trailing: const Icon(Icons.chevron_right, color: AppColors.iconGrey),
                      onTap: () {
                        if (item['title'] == 'Ubah Profil') {
                          context.push('/profile/edit');
                        } else if (item['title'] == 'Data Rekam Medis') {
                          context.push('/medical-results');
                        } else if (item['title'] == 'Anggota Keluarga') {
                          context.push('/profile/family-members');
                        } else if (item['title'] == 'Pengaturan') {
                          context.push('/profile/settings');
                        } else if (item['title'] == 'Bantuan & Dukungan') {
                          context.push('/profile/help-support');
                        } else {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).hideCurrentSnackBar(); ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Menu ${item['title']} segera hadir!'),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(milliseconds: 1500),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        }
                      },
                    )),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.logout, color: Colors.red),
                  ),
                  title: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    globalAuthToken = null;
                    ref.invalidate(userProfileProvider);
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
