import '../../../../core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../models/cart.dart';

class CheckoutOrderSummary extends StatelessWidget {
  final String pickupMethod;
  final Cart cart;

  const CheckoutOrderSummary({
    super.key,
    required this.pickupMethod,
    required this.cart,
  });

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
          ),
        ],
      ),
      child: Column(
        children: [
          ...cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.medicine.name} (${item.quantity})',
                    style: const TextStyle(color: AppColors.textDark),
                  ),
                  Text(
                    'Rp ${(item.medicine.price * item.quantity).toInt()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 24, color: AppColors.dividerGrey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.extSubtotal,
                style: TextStyle(color: AppColors.textGrey),
              ),
              Text(
                'Rp ${cart.totalPrice.toInt()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.extOngkoskirim,
                style: TextStyle(color: AppColors.textGrey),
              ),
              Text(
                pickupMethod == 'Delivery' ? 'Rp 10.000' : 'Rp 0',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
