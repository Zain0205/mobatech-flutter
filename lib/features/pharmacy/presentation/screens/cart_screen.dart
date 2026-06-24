import '../../../../core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/pharmacy_provider.dart';

part 'cart_screen_widgets.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLightGrey,
      appBar: AppBar(
        title: const Text(
          AppStrings.extKeranjang,
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.backgroundWhite,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        elevation: 0,
      ),
      body: cartAsync.when(
        data: (cart) => _CartItemList(cart: cart),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            const Center(child: Text(AppStrings.extGagalmemuatkeranjang)),
      ),
      bottomNavigationBar: cartAsync.whenOrNull(
        data: (cart) {
          if (cart.items.isEmpty) return null;
          return _CartBottomBar(cart: cart);
        },
      ),
    );
  }
}

