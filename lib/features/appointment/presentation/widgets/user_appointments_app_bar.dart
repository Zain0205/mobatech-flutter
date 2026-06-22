import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class UserAppointmentsAppBar extends StatelessWidget {
  const UserAppointmentsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.textWhite),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Janji Temu Saya',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        background: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -20,
              top: -10,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset('assets/header_logo.png', width: 220),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
