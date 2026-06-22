import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/profile_provider.dart';

class ProfileMenuSection extends ConsumerWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.white.withValues(alpha: 0.85),
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
                          ScaffoldMessenger.of(context).showSnackBar(
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
                    decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
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
