import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class CheckoutOrderSummary extends StatelessWidget {
  final String pickupMethod;

  const CheckoutOrderSummary({super.key, required this.pickupMethod});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Amoxicillin 500mg (15)', style: TextStyle(color: AppColors.textDark)),
              Text('Rp 25.000', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Panadol Extra (1)', style: TextStyle(color: AppColors.textDark)),
              Text('Rp 15.000', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 24, color: AppColors.dividerGrey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Subtotal', style: TextStyle(color: AppColors.textGrey)),
              Text('Rp 40.000', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ongkos Kirim', style: TextStyle(color: AppColors.textGrey)),
              Text(pickupMethod == 'Delivery' ? 'Rp 10.000' : 'Rp 0', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
