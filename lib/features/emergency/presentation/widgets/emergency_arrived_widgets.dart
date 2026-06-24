import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class ArrivedCheckmark extends StatelessWidget {
  const ArrivedCheckmark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.backgroundWhite.withAlpha(30),
        border: Border.all(color: AppColors.backgroundWhite.withAlpha(60), width: 3),
      ),
      child: const Icon(Icons.check_rounded, color: AppColors.backgroundWhite, size: 64),
    );
  }
}

class ArrivedMessage extends StatelessWidget {
  const ArrivedMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          AppStrings.ambulanceArrived,
          style: TextStyle(
            color: AppColors.backgroundWhite,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppStrings.arrivedMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.backgroundWhite.withAlpha(200),
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class ArrivedDriverCard extends StatelessWidget {
  const ArrivedDriverCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.backgroundWhite.withAlpha(40)),
      ),
      child: const Row(
        children: [
          Icon(Icons.local_shipping, color: AppColors.backgroundWhite, size: 28),
          SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.driverInfoArrived,
                style: TextStyle(
                  color: AppColors.backgroundWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                AppStrings.ambulanceType,
                style: TextStyle(color: AppColors.textWhite70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BackToHomeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BackToHomeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundWhite,
          foregroundColor: AppColors.arrivedGreen2,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          AppStrings.backToHome,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
