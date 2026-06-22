import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import 'location_card.dart';
import 'emergency_form_field.dart';

class EmergencyFormView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController patientNameController;
  final TextEditingController conditionController;
  final TextEditingController phoneController;
  final double? userLat;
  final double? userLng;
  final bool isLocating;
  final String? locationError;
  final MapController formMapController;
  final bool isLoading;
  final VoidCallback onDetectLocation;
  final VoidCallback onSubmit;

  const EmergencyFormView({
    super.key,
    required this.formKey,
    required this.patientNameController,
    required this.conditionController,
    required this.phoneController,
    required this.userLat,
    required this.userLng,
    required this.isLocating,
    required this.locationError,
    required this.formMapController,
    required this.isLoading,
    required this.onDetectLocation,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: CustomScrollView(
          key: const ValueKey('form'),
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.errorRed,
              foregroundColor: Colors.white,
              title: const Text(
                AppStrings.emergencyTitle,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              centerTitle: true,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              flexibleSpace: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Opacity(
                        opacity: 0.4,
                        child: Image.asset('assets/header_logo.png', width: 220),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Warning banner
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.errorRed.withAlpha(13),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.errorRed.withAlpha(51)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(Icons.warning_amber_rounded, color: AppColors.errorRed, size: 32),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      AppStrings.emergencyWarning,
                                      style: TextStyle(
                                        color: AppColors.errorRed,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // GPS Location Section
                      _buildSectionLabel(AppStrings.locationLabel, Icons.my_location),
                      const SizedBox(height: 12),
                      LocationCard(
                        userLat: userLat,
                        userLng: userLng,
                        isLocating: isLocating,
                        locationError: locationError,
                        formMapController: formMapController,
                        onDetectLocation: onDetectLocation,
                      ),

                      const SizedBox(height: 24),

                      // Form Fields
                      _buildSectionLabel(AppStrings.patientDataLabel, Icons.person_outline),
                      const SizedBox(height: 12),
                      EmergencyFormField(
                        controller: patientNameController,
                        hint: AppStrings.patientNameHint,
                        icon: Icons.person,
                      ),

                      const SizedBox(height: 14),
                      EmergencyFormField(
                        controller: conditionController,
                        hint: AppStrings.conditionHint,
                        icon: Icons.medical_services_outlined,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 14),
                      EmergencyFormField(
                        controller: phoneController,
                        hint: AppStrings.phoneActiveHint,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 32),

                      // Submit Button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.errorRed.withAlpha(100),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: (isLoading || userLat == null) ? null : onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.errorRed,
                            disabledBackgroundColor: AppColors.buttonDisabled,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.emergency, size: 22),
                                    SizedBox(width: 10),
                                    Text(
                                      AppStrings.callAmbulance,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textGrey),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textGrey,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
