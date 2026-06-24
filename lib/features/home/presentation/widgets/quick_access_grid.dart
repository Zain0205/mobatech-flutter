import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../services/presentation/providers/service_provider.dart';
import 'quick_access_item.dart';
import 'quick_access_more_menu.dart';

class QuickAccessGrid extends ConsumerWidget {
  const QuickAccessGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return servicesAsync.when(
      data: (services) {
        final List<Widget> menuItems = [
          QuickAccessItem(
            icon: Icons.calendar_month_outlined,
            label: AppStrings.menuAppointment,
            iconColor: AppColors.primary,
            onTap: () => context.push('/appointment'),
          ),
          QuickAccessItem(
            icon: Icons.card_giftcard_outlined,
            label: AppStrings.menuOffers,
            iconColor: AppColors.primary,
            onTap: () => context.push('/special-offers'),
          ),
          QuickAccessItem(
            icon: Icons.smart_toy_outlined,
            label: AppStrings.menuAssistant,
            iconColor: AppColors.primary,
            onTap: () => context.push('/chatbot'),
          ),
          QuickAccessItem(
            icon: Icons.emergency_outlined,
            label: AppStrings.menuEmergency,
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
              label: AppStrings.menuOthers,
              iconColor: AppColors.primary,
              onTap: () {
                showQuickAccessMoreMenu(context, remainingItems);
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
