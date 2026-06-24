import '../../../../core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../providers/profile_provider.dart';
import '../widgets/family_member_card.dart';
import '../widgets/add_family_member_modal.dart';

class FamilyMembersScreen extends ConsumerWidget {
  const FamilyMembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: AppBar(
        title: Text(
          AppStrings.extAnggotakeluarga,
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.backgroundWhite),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24),
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
            ],
          ),
        ),
      ),
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: profileAsync.when(
              data: (user) {
                if (user == null) {
                  return const Center(
                    child: Text(AppStrings.extDatatidakditemukan),
                  );
                }

                final familyList = user.familyMembers ?? [];

                return ListView(
                  padding: const EdgeInsets.all(24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    FamilyMemberCard(
                      name: user.fullName,
                      relation: 'Pemilik Akun',
                      isPrimary: true,
                      email: user.email,
                      phone: user.phone,
                      dob: user.dob,
                      gender: user.gender,
                    ),
                    const SizedBox(height: 16),
                    ...familyList.map((member) {
                      final m = member as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: FamilyMemberCard(
                          name: m['full_name'] ?? 'Tanpa Nama',
                          relation: m['relationship'] ?? 'Keluarga',
                          isPrimary: false,
                          id: m['ID'],
                          dob: m['date_of_birth'],
                          gender: m['gender'],
                        ),
                      );
                    }),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text(ErrorHandler.getMessage(e))),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddMemberModal(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.backgroundWhite),
        label: Text(
          AppStrings.extTambahanggota,
          style: TextStyle(color: AppColors.backgroundWhite, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
