import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(vsync: this, duration: AppDurations.slideUp)..forward();
    _fadeController = AnimationController(vsync: this, duration: AppDurations.fadeIn);
    
    Future.delayed(AppDurations.staggerDelay, () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Column(
        children: [
          Container(
            height: size.height * 0.55,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppSizes.borderRadiusCard),
                bottomRight: Radius.circular(AppSizes.borderRadiusCard),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -20,
                  right: -40,
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset('assets/header_logo.png', width: 220),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
                      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
                    ),
                    child: Image.asset('assets/doctor.png', height: size.height * 0.4),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: FadeTransition(
                opacity: _fadeController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.welcomeTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.2),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      AppStrings.welcomeSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: AppColors.textGrey, height: 1.5),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: AppSizes.buttonHeightLarge,
                      child: ElevatedButton(
                        onPressed: () => context.go('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textWhite,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.borderRadiusXL)),
                          elevation: 0,
                        ),
                        child: const Text(AppStrings.getStarted, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
