part of 'register_form.dart';

class _NameInputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _NameInputSection({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthLabel(text: AppStrings.fullNameLabel),
        const SizedBox(height: 8),
        AuthTextField(
          hint: AppStrings.fullNameHint,
          controller: controller,
          validator: (v) => Validators.validateName(v, AppStrings.fullNameLabel),
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}

class _EmailInputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _EmailInputSection({required this.controller, required this.onChanged});

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

class _PhoneInputSection extends StatelessWidget {
  final TextEditingController controller;

  const _PhoneInputSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthLabel(text: AppStrings.phoneLabel),
        const SizedBox(height: 8),
        PhoneTextField(
          controller: controller,
          validator: Validators.validatePhone,
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
          controller: controller,
          obscureText: obscurePassword,
          validator: Validators.validatePassword,
          onChanged: (_) => onChanged(),
          onTogglePassword: onTogglePassword,
        ),
      ],
    );
  }
}

class _ConfirmPasswordInputSection extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  final bool obscureConfirm;
  final VoidCallback onChanged;
  final VoidCallback onTogglePassword;

  const _ConfirmPasswordInputSection({
    required this.controller,
    required this.passwordController,
    required this.obscureConfirm,
    required this.onChanged,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthLabel(text: AppStrings.confirmPasswordLabel),
        const SizedBox(height: 8),
        AuthTextField(
          hint: AppStrings.confirmPasswordHint,
          isPassword: true,
          controller: controller,
          obscureText: obscureConfirm,
          validator: (v) => Validators.validateConfirmPassword(v, passwordController.text),
          onChanged: (_) => onChanged(),
          onTogglePassword: onTogglePassword,
        ),
      ],
    );
  }
}
