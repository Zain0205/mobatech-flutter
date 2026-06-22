import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/error_handler.dart';
import 'auth_label.dart';
import 'auth_text_field.dart';
import 'phone_text_field.dart';
import 'social_login_button.dart';
import '../providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_phoneController.text.length < 8) {
      _showError(AppStrings.phoneMinError);
      return;
    }
    final confirmError = Validators.validateConfirmPassword(_confirmPasswordController.text, _passwordController.text);
    if (confirmError != null) {
      _showError(confirmError);
      return;
    }

    try {
      await ref.read(authStateProvider.notifier).register(
        _nameController.text,
        _emailController.text,
        '+62${_phoneController.text}',
        _passwordController.text,
      );
      ref.invalidate(userProfileProvider);
      if (mounted) context.go('/home');
    } catch (e) {
      _showError(ErrorHandler.getMessage(e));
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg, style: const TextStyle(color: AppColors.textWhite)),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authStateProvider);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthLabel(text: AppStrings.fullNameLabel),
          const SizedBox(height: 8),
          AuthTextField(
            hint: AppStrings.fullNameHint,
            controller: _nameController,
            validator: (v) => Validators.validateRequired(v, AppStrings.fullNameLabel),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          const AuthLabel(text: AppStrings.emailLabel),
          const SizedBox(height: 8),
          AuthTextField(
            hint: AppStrings.emailHint,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          const AuthLabel(text: AppStrings.phoneLabel),
          const SizedBox(height: 8),
          PhoneTextField(controller: _phoneController),
          const SizedBox(height: 20),
          const AuthLabel(text: AppStrings.passwordLabel),
          const SizedBox(height: 8),
          AuthTextField(
            hint: AppStrings.passwordHint,
            isPassword: true,
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: Validators.validatePassword,
            onChanged: (_) => setState(() {}),
            onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 12),
          _buildPasswordValidations(),
          const SizedBox(height: 20),
          const AuthLabel(text: AppStrings.confirmPasswordLabel),
          const SizedBox(height: 8),
          AuthTextField(
            hint: AppStrings.confirmPasswordHint,
            isPassword: true,
            controller: _confirmPasswordController,
            obscureText: _obscureConfirm,
            onChanged: (_) => setState(() {}),
            onTogglePassword: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeight,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.borderRadiusXL)),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text(AppStrings.registerButton, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(child: Divider(color: AppColors.dividerGrey, thickness: 1.5)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(AppStrings.orContinueWith, style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
              ),
              Expanded(child: Divider(color: AppColors.dividerGrey, thickness: 1.5)),
            ],
          ),
          const SizedBox(height: 24),
          SocialLoginButton(
            text: AppStrings.continueWithGoogle,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Firebase Auth Google Sign-In: Coming Soon!')));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordValidations() {
    final pwd = _passwordController.text;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _validationItem(AppStrings.passMinChars, pwd.length >= 8),
        _validationItem(AppStrings.passUppercase, RegExp(r'[A-Z]').hasMatch(pwd)),
        _validationItem(AppStrings.passLowercase, RegExp(r'[a-z]').hasMatch(pwd)),
        _validationItem(AppStrings.passDigit, RegExp(r'[0-9]').hasMatch(pwd)),
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
