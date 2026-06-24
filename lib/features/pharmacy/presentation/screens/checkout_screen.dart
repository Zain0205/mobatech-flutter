import '../../../../core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/checkout_order_summary.dart';
import '../widgets/checkout_pickup_method.dart';
import '../widgets/checkout_payment_method.dart';
import '../widgets/checkout_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/pharmacy_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _pickupMethod = 'Delivery';
  String _paymentMethod = 'Transfer';

  @override
  Widget build(BuildContext context) {
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLightGrey,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: cartAsync.when(
        data: (cart) {
          if (cart.items.isEmpty) {
            return const Center(child: Text(AppStrings.extKeranjangandakosong));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Ringkasan Pesanan'),
                CheckoutOrderSummary(pickupMethod: _pickupMethod, cart: cart),
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
                const SizedBox(height: 100),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) =>
            const Center(child: Text(AppStrings.extGagalmemuatpesanan)),
      ),
      bottomSheet: cartAsync.whenOrNull(
        data: (cart) {
          if (cart.items.isEmpty) return null;
          final ongkir = _pickupMethod == 'Delivery' ? 10000 : 0;
          final grandTotal = cart.totalPrice + ongkir;
          return CheckoutBottomSheet(grandTotal: grandTotal);
        },
      ),
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
