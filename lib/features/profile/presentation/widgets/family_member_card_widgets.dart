import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class FamilyMemberMenu extends ConsumerWidget {
  final int id;

  const FamilyMemberMenu({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.iconGrey),
      color: AppColors.backgroundWhite,
      onSelected: (value) async {
        if (value == 'delete') {
          try {
            await ref.read(authStateProvider.notifier).deleteFamilyMember(id);
            ref.invalidate(userProfileProvider);
            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              CustomSnackbar.showSuccess(context, AppStrings.extAnggotakeluargaberhasildihapus);
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              CustomSnackbar.showError(context, ErrorHandler.getMessage(e));
            }
          }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: AppColors.errorRed, size: 20),
              SizedBox(width: 8),
              Text(AppStrings.extHapus, style: TextStyle(color: AppColors.errorRed)),
            ],
          ),
        ),
      ],
    );
  }
}

class FamilyMemberAvatar extends StatelessWidget {
  final String name;
  final bool isPrimary;

  const FamilyMemberAvatar({
    super.key,
    required this.name,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: isPrimary
          ? AppColors.primary
          : AppColors.textGrey.withValues(alpha: 0.2),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isPrimary ? AppColors.backgroundWhite : AppColors.textDark,
        ),
      ),
    );
  }
}
