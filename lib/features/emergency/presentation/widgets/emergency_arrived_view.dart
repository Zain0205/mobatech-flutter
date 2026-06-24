import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'emergency_arrived_widgets.dart';

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
                  const ArrivedCheckmark(),
                  const SizedBox(height: 32),
                  const ArrivedMessage(),
                  const SizedBox(height: 16),
                  const ArrivedDriverCard(),
                  const SizedBox(height: 32),
                  BackToHomeButton(
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
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
