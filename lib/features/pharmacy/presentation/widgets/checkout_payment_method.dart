import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class CheckoutPaymentMethod extends StatelessWidget {
  final String paymentMethod;
  final ValueChanged<String> onChanged;

  const CheckoutPaymentMethod({
    super.key,
    required this.paymentMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPaymentOption(
          'Transfer Bank',
          'Transfer',
          Icons.account_balance_outlined,
        ),
        const SizedBox(height: 12),
        _buildPaymentOption('Tunai (Cash)', 'Cash', Icons.money_outlined),
        const SizedBox(height: 12),
        _buildPaymentOption(
          'BPJS Kesehatan',
          'BPJS',
          Icons.health_and_safety_outlined,
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String title, String value, IconData icon) {
    final isSelected = paymentMethod == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.iconGrey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.textDark : AppColors.textGrey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
