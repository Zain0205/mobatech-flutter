import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class EmergencyDispatchingView extends StatefulWidget {
  const EmergencyDispatchingView({super.key});

  @override
  State<EmergencyDispatchingView> createState() => _EmergencyDispatchingViewState();
}

class _EmergencyDispatchingViewState extends State<EmergencyDispatchingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('dispatching'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.emergencyDark1, AppColors.emergencyDark2],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulsating ambulance icon
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.errorRed.withAlpha(30),
                        border: Border.all(
                          color: AppColors.errorRed.withAlpha(
                              (100 * _pulseAnimation.value).toInt()),
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.local_hospital,
                        color: AppColors.errorRed,
                        size: 52,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              const Text(
                AppStrings.searchingAmbulance,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.contactingEmergencyUnit,
                style: TextStyle(
                  color: Colors.white.withAlpha(180),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withAlpha(25),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.errorRed),
                  minHeight: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
