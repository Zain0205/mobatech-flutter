part of 'login_form.dart';

class _EmailInputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _EmailInputSection({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthLabel(text: AppStrings.emailLabel),
        const SizedBox(height: 8),
        AuthTextField(
          hint: AppStrings.emailHint,
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.validateEmail,
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}

class _PasswordInputSection extends StatelessWidget {
  final TextEditingController controller;
  final bool obscurePassword;
  final VoidCallback onChanged;
  final VoidCallback onTogglePassword;

  const _PasswordInputSection({
    required this.controller,
    required this.obscurePassword,
    required this.onChanged,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthLabel(text: AppStrings.passwordLabel),
        const SizedBox(height: 8),
        AuthTextField(
          hint: AppStrings.passwordHint,
          isPassword: true,
          obscureText: obscurePassword,
          controller: controller,
          validator: Validators.validatePassword,
          onChanged: (_) => onChanged(),
          onTogglePassword: onTogglePassword,
        ),
      ],
    );
  }
}

class _LoginFormOptions extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;

  const _LoginFormOptions({
    required this.rememberMe,
    required this.onRememberMeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: rememberMe,
                activeColor: AppColors.primary,
                checkColor: AppColors.textWhite,
                side: const BorderSide(
                  color: AppColors.borderGrey,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: onRememberMeChanged,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              AppStrings.rememberMe,
              style: TextStyle(color: AppColors.textGrey, fontSize: 14),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            AppStrings.forgotPassword,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
