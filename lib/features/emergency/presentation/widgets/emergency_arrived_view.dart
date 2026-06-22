import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class EmergencyArrivedView extends StatefulWidget {
  const EmergencyArrivedView({super.key});

  @override
  State<EmergencyArrivedView> createState() => _EmergencyArrivedViewState();
}

class _EmergencyArrivedViewState extends State<EmergencyArrivedView>
    with SingleTickerProviderStateMixin {
  late AnimationController _arrivedController;
  late Animation<double> _arrivedScaleAnimation;
  late Animation<double> _arrivedOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _arrivedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _arrivedScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _arrivedController, curve: Curves.elasticOut),
    );
    _arrivedOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _arrivedController, curve: Curves.easeIn),
    );

    _arrivedController.forward();
  }

  @override
  void dispose() {
    _arrivedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('arrived'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.arrivedGreen1, AppColors.arrivedGreen2],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _arrivedController,
            builder: (context, child) {
              return Opacity(
                opacity: _arrivedOpacityAnimation.value,
                child: Transform.scale(
                  scale: _arrivedScaleAnimation.value,
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Checkmark circle
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(30),
                      border: Border.all(color: Colors.white.withAlpha(60), width: 3),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    AppStrings.ambulanceArrived,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.arrivedMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withAlpha(200),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Driver info card
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withAlpha(40)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.local_shipping, color: Colors.white, size: 28),
                        SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.driverInfoArrived,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              AppStrings.ambulanceType,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Back to home button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.arrivedGreen2,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        AppStrings.backToHome,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
