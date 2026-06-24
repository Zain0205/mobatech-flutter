import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import 'location_card.dart';
import 'emergency_form_field.dart';
import 'emergency_form_widgets.dart';
import 'emergency_submit_button.dart';
import '../../../../core/utils/validators.dart';

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
            const EmergencyAppBar(),
            SliverToBoxAdapter(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Warning banner
                      const EmergencyWarningBanner(),

                      const SizedBox(height: 28),

                      // GPS Location Section
                      _buildSectionLabel(
                        AppStrings.locationLabel,
                        Icons.my_location,
                      ),
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
                      _buildSectionLabel(
                        AppStrings.patientDataLabel,
                        Icons.person_outline,
                      ),
                      const SizedBox(height: 12),
                      EmergencyFormField(
                        controller: patientNameController,
                        hint: AppStrings.patientNameHint,
                        icon: Icons.person,
                        validator: (v) => Validators.validateName(v, 'Nama Pasien'),
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
                        validator: Validators.validatePhone,
                      ),

                      const SizedBox(height: 32),

                      // Submit Button
                      EmergencySubmitButton(
                        isLoading: isLoading,
                        hasLocation: userLat != null,
                        onSubmit: onSubmit,
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
