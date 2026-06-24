import '../../../../core/constants/app_strings.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/mock_ui_providers.dart';

part 'offer_detail_screen_components.dart';

class OfferDetailScreen extends StatelessWidget {
  final SpecialOffer offer;

  const OfferDetailScreen({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: const _OfferDetailAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _OfferCard(offer: offer),
            const SizedBox(height: 32),
            const Text(
              'Syarat & Ketentuan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Promo ini hanya berlaku untuk pengguna terdaftar di aplikasi Mobatech.\n2. Tidak dapat digabungkan dengan promo lainnya.\n3. Harap tunjukkan halaman ini saat Anda berada di resepsionis Rumah Sakit Hermina.\n4. Syarat dan ketentuan dapat berubah sewaktu-waktu.',
              style: TextStyle(
                fontSize: 16,
                height: 1.8,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 40),
            _ClaimButton(offer: offer),
          ],
        ),
      ),
    );
  }
}
