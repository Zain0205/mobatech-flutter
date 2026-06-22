import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../providers/pharmacy_provider.dart';
import '../widgets/shimmer_loading.dart';

class OrdersTabView extends ConsumerWidget {
  const OrdersTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return ordersAsync.when(
      data: (orders) {
        if (orders.isEmpty) {
          return const Center(child: Text(AppStrings.noOrders));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: orders.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final order = orders[index];
            return GestureDetector(
              onTap: () => context.push('/pharmacy/tracking'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: AppColors.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                          child: Text(order.status, style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.inventory_2_outlined, color: AppColors.textGrey, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order.items.map((e) => e.medicine.name).join(', '),
                            style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: AppColors.dividerGrey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(AppStrings.totalOrder, style: TextStyle(color: AppColors.textDark, fontSize: 14)),
                        Text('Rp ${order.totalPrice.toInt()}', style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => const ShimmerLoading(width: double.infinity, height: 140, borderRadius: 16),
      ),
      error: (err, stack) => const Center(child: Text(AppStrings.errorLoadOrders)),
    );
  }
}
