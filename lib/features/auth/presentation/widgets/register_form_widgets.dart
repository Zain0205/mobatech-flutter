import 'package:flutter/material.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import 'social_login_button.dart';

class RegisterSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const RegisterSubmitButton({
    super.key,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: AppSizes.buttonHeight,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusXL),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.backgroundWhite,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    AppStrings.registerButton,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
        const SizedBox(height: 24),
        const Row(
          children: [
            Expanded(
              child: Divider(color: AppColors.dividerGrey, thickness: 1.5),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppStrings.orContinueWith,
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
            ),
            Expanded(
              child: Divider(color: AppColors.dividerGrey, thickness: 1.5),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SocialLoginButton(
          text: AppStrings.continueWithGoogle,
          onPressed: () {
            CustomSnackbar.showInfo(context, AppStrings.extFirebaseauthgooglesignincomingsoon);
          },
        ),
      ],
    );
  }
}

class PasswordValidationRules extends StatelessWidget {
  final String password;

  const PasswordValidationRules({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _validationItem(AppStrings.passMinChars, password.length >= 8),
        _validationItem(
          AppStrings.passUppercase,
          RegExp(r'[A-Z]').hasMatch(password),
        ),
        _validationItem(
          AppStrings.passLowercase,
          RegExp(r'[a-z]').hasMatch(password),
        ),
        _validationItem(
          AppStrings.passDigit,
          RegExp(r'[0-9]').hasMatch(password),
        ),
      ],
    );
  }

  Widget _validationItem(String text, bool isValid) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.check_circle_outline,
          color: isValid ? AppColors.successGreen : AppColors.iconLightGrey,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isValid ? AppColors.textDark : AppColors.textLightGrey,
          ),
        ),
      ],
    );
  }
}
