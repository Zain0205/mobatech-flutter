import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomSnackbar {
  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(context, message, AppColors.successGreen);
  }

  static void showError(BuildContext context, String message) {
    _showSnackbar(context, message, AppColors.errorRed);
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackbar(context, message, AppColors.textDark);
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackbar(context, message, AppColors.warningOrange);
  }

  static void _showSnackbar(BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
