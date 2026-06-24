import 'package:flutter/material.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/error_handler.dart';
import 'auth_label.dart';
import 'auth_text_field.dart';
import 'phone_text_field.dart';
import '../providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import 'register_form_widgets.dart';

part 'register_form_parts.dart';

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
    final confirmError = Validators.validateConfirmPassword(
      _confirmPasswordController.text,
      _passwordController.text,
    );
    if (confirmError != null) {
      _showError(confirmError);
      return;
    }

    try {
      await ref
          .read(authStateProvider.notifier)
          .register(
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
      CustomSnackbar.showError(context, msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildFormContent(),
      ),
    );
  }

  List<Widget> _buildFormContent() {
    final isLoading = ref.watch(authStateProvider);
    return [
      _NameInputSection(
        controller: _nameController,
        onChanged: () => setState(() {}),
      ),
      const SizedBox(height: 20),
      _EmailInputSection(
        controller: _emailController,
        onChanged: () => setState(() {}),
      ),
      const SizedBox(height: 20),
      _PhoneInputSection(controller: _phoneController),
      const SizedBox(height: 20),
      _PasswordInputSection(
        controller: _passwordController,
        obscurePassword: _obscurePassword,
        onChanged: () => setState(() {}),
        onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
      const SizedBox(height: 12),
      PasswordValidationRules(password: _passwordController.text),
      const SizedBox(height: 20),
      _ConfirmPasswordInputSection(
        controller: _confirmPasswordController,
        passwordController: _passwordController,
        obscureConfirm: _obscureConfirm,
        onChanged: () => setState(() {}),
        onTogglePassword: () => setState(() => _obscureConfirm = !_obscureConfirm),
      ),
      const SizedBox(height: 40),
      RegisterSubmitButton(
        isLoading: isLoading,
        onPressed: isLoading ? null : _handleRegister,
      ),
    ];
  }
}
