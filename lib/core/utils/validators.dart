import '../constants/app_strings.dart';

class Validators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${AppStrings.requiredField.toLowerCase()}';
    }
    return null;
  }

  static String? validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${AppStrings.requiredField.toLowerCase()}';
    }
    // Restrict name field to alphabetic characters and common separators.
    final nameRegex = RegExp(r"^[a-zA-Z\s\.,'-]+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return AppStrings.errInvalidName;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    // RFC 5322 compliant email regex pattern.
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.errValidation;
    }

    // Domain validation for recognized email providers.
    final allowedDomains = [
      'gmail.com',
      'yahoo.com',
      'yahoo.co.id',
      'outlook.com',
      'hotmail.com',
      'icloud.com'
    ];
    
    final domain = value.trim().split('@').last.toLowerCase();
    if (!allowedDomains.contains(domain)) {
      return AppStrings.errInvalidEmailDomain;
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    // Strip non-numeric characters for length validation.
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8 || digits.length > 15) {
      return AppStrings.errInvalidPhone;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    // Enforce password complexity: Min 8 chars, mixed case, alphanumeric.
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d\w\W]{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return AppStrings.errWeakPassword;
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    if (value != originalPassword) {
      return AppStrings.errPasswordMismatch;
    }
    return null;
  }
}
