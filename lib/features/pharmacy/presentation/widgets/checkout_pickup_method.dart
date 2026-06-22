import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class CheckoutPickupMethod extends StatelessWidget {
  final String pickupMethod;
  final ValueChanged<String> onChanged;

  const CheckoutPickupMethod({
    super.key,
    required this.pickupMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSelectableCard(
            title: 'Delivery',
            icon: Icons.local_shipping_outlined,
            isSelected: pickupMethod == 'Delivery',
            onTap: () => onChanged('Delivery'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSelectableCard(
            title: 'Pickup at Counter',
            icon: Icons.storefront_outlined,
            isSelected: pickupMethod == 'Pickup',
            onTap: () => onChanged('Pickup'),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectableCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: isSelected ? AppColors.primary : AppColors.iconGrey),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
