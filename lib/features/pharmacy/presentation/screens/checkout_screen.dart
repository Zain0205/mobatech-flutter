import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/checkout_order_summary.dart';
import '../widgets/checkout_pickup_method.dart';
import '../widgets/checkout_payment_method.dart';
import '../widgets/checkout_bottom_sheet.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _pickupMethod = 'Delivery';
  String _paymentMethod = 'Transfer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLightGrey,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Ringkasan Pesanan'),
            CheckoutOrderSummary(pickupMethod: _pickupMethod),
            const SizedBox(height: 24),
            _buildSectionTitle('Metode Pengambilan'),
            CheckoutPickupMethod(
              pickupMethod: _pickupMethod,
              onChanged: (val) => setState(() => _pickupMethod = val),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Metode Pembayaran'),
            CheckoutPaymentMethod(
              paymentMethod: _paymentMethod,
              onChanged: (val) => setState(() => _paymentMethod = val),
            ),
            const SizedBox(height: 100), // spacing for bottom bar
          ],
        ),
      ),
      bottomSheet: const CheckoutBottomSheet(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
