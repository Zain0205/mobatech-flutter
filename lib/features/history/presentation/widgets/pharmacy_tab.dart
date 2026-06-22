import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/providers/mock_ui_providers.dart';
import 'history_card.dart';

class PharmacyTab extends ConsumerWidget {
  const PharmacyTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(pharmacyHistoryProvider);
    return ordersAsync.when(
      data: (orders) {
        if (orders.isEmpty) return const Center(child: Text(AppStrings.noPharmacyHistory, style: TextStyle(color: AppColors.textGrey)));
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: HistoryCard(
                title: order.title, 
                status: order.status, 
                date: order.date, 
                onTap: () => context.push('/pharmacy/tracking', extra: order)
              ),
            );
          },
        );
      },
      loading: () => const CardSkeletonLoader(count: 3),
      error: (e, stack) => _buildErrorState(ErrorHandler.getMessage(e)),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: AppColors.textLightGrey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
