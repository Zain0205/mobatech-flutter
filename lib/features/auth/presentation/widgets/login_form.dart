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
import 'social_login_button.dart';
import '../providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../appointment/providers/appointment_provider.dart';
import '../../../services/presentation/providers/service_provider.dart';
import '../../../chatbot/presentation/providers/chat_provider.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await ref.read(authStateProvider.notifier).login(_emailController.text, _passwordController.text);
      ref.invalidate(userProfileProvider);
      ref.invalidate(userAppointmentsProvider);
      ref.invalidate(servicesProvider);
      ref.invalidate(chatSessionsProvider);
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getMessage(e), style: const TextStyle(color: AppColors.textWhite)),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    final isLoading = ref.watch(authStateProvider);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthLabel(text: AppStrings.emailLabel),
          const SizedBox(height: 8),
          AuthTextField(
            hint: AppStrings.emailHint,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          const AuthLabel(text: AppStrings.passwordLabel),
          const SizedBox(height: 8),
          AuthTextField(
            hint: AppStrings.passwordHint,
            isPassword: true,
            obscureText: _obscurePassword,
            controller: _passwordController,
            validator: Validators.validatePassword,
            onChanged: (_) => setState(() {}),
            onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 24, height: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      activeColor: AppColors.primary,
                      checkColor: AppColors.textWhite,
                      side: const BorderSide(color: AppColors.borderGrey, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (v) => setState(() => _rememberMe = v ?? false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(AppStrings.rememberMe, style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text(AppStrings.forgotPassword, style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeight,
            child: ElevatedButton(
              onPressed: (isButtonEnabled && !isLoading) ? _handleLogin : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.buttonDisabled,
                foregroundColor: AppColors.textWhite,
                disabledForegroundColor: AppColors.buttonDisabledText,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.borderRadiusXL)),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text(AppStrings.loginButton, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          SocialLoginButton(
            text: AppStrings.continueWithGoogle,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Firebase Auth Google Sign-In: Coming Soon!')));
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(AppStrings.noAccount, style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
              GestureDetector(
                onTap: () => context.push('/register'),
                child: const Text(AppStrings.registerLink, style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
