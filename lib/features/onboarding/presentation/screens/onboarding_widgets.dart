part of 'onboarding_screen.dart';

class _OnboardingImageSection extends StatelessWidget {
  final Size size;
  final AnimationController slideController;

  const _OnboardingImageSection({
    required this.size,
    required this.slideController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _buildLogoOpacity(),
          _buildDoctorImage(),
        ],
      ),
    );
  }

  Widget _buildLogoOpacity() {
    return Positioned(
      top: -20,
      right: -40,
      child: Opacity(
        opacity: 0.3,
        child: Image.asset('assets/header_logo.png', width: 220),
      ),
    );
  }

  Widget _buildDoctorImage() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: slideController, curve: Curves.easeOutCubic),
        ),
        child: Image.asset('assets/doctor.png', height: size.height * 0.4),
      ),
    );
  }
}

class _OnboardingTextSection extends StatelessWidget {
  final AnimationController fadeController;

  const _OnboardingTextSection({required this.fadeController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: FadeTransition(
          opacity: fadeController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle(),
              const SizedBox(height: 16),
              _buildSubtitle(),
              const SizedBox(height: 40),
              _buildGetStartedButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      AppStrings.welcomeTitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
        height: 1.2,
      ),
    );
  }

  Widget _buildSubtitle() {
    return const Text(
      AppStrings.welcomeSubtitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
        color: AppColors.textGrey,
        height: 1.5,
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeightLarge,
      child: ElevatedButton(
        onPressed: () => context.go('/login'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusXL),
          ),
          elevation: 0,
        ),
        child: const Text(
          AppStrings.getStarted,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
