import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../patient_support/providers/patient_support_provider.dart';
import 'home_header_parts.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider).value;
    final firstName =
        userProfile?.fullName.split(' ').first ?? AppStrings.defaultUser;

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
                        backgroundColor: AppColors.backgroundWhite.withValues(alpha: 0.2),
                        backgroundImage: userProfile?.imagePath != null
                            ? (userProfile!.imagePath!.startsWith('http')
                                  ? NetworkImage(userProfile.imagePath!)
                                        as ImageProvider
                                  : FileImage(File(userProfile.imagePath!)))
                            : null,
                        child: userProfile?.imagePath == null
                            ? const Icon(
                                Icons.person,
                                color: AppColors.textWhite,
                                size: 28,
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppStrings.homeGreetingPrefix}$firstName',
                              style: const TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              AppStrings.homeGreetingSubtitle,
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
                          final unreadCountAsync = ref.watch(
                            unreadReminderCountProvider,
                          );
                          return Stack(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  color: AppColors.textWhite,
                                  size: 28,
                                ),
                                onPressed: () => context.push('/notifications'),
                              ),
                              if (unreadCountAsync.value != null &&
                                  unreadCountAsync.value! > 0)
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
                                      style: const TextStyle(
                                        color: AppColors.textWhite,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                  const HomeHeaderSearchField(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
