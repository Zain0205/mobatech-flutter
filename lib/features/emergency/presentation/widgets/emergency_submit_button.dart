import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class EmergencySubmitButton extends StatelessWidget {
  final bool isLoading;
  final bool hasLocation;
  final VoidCallback onSubmit;

  const EmergencySubmitButton({
    super.key,
    required this.isLoading,
    required this.hasLocation,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onPressed: (isLoading || !hasLocation) ? null : onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.errorRed,
          disabledBackgroundColor: AppColors.buttonDisabled,
          foregroundColor: AppColors.backgroundWhite,
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
                  color: AppColors.backgroundWhite,
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
    );
  }
}
