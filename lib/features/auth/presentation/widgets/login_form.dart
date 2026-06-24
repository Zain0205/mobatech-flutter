import 'package:flutter/material.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/error_handler.dart';
import 'auth_label.dart';
import 'auth_text_field.dart';
import '../providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../appointment/providers/appointment_provider.dart';
import '../../../services/presentation/providers/service_provider.dart';
import '../../../chatbot/presentation/providers/chat_provider.dart';
import 'login_form_widgets.dart';

part 'login_form_parts.dart';

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
      await ref
          .read(authStateProvider.notifier)
          .login(_emailController.text, _passwordController.text);
      ref.invalidate(userProfileProvider);
      ref.invalidate(userAppointmentsProvider);
      ref.invalidate(servicesProvider);
      ref.invalidate(chatSessionsProvider);
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        CustomSnackbar.showError(context, ErrorHandler.getMessage(e));
      }
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
    final canSubmit =
        _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    return [
      _EmailInputSection(
        controller: _emailController,
        onChanged: () => setState(() {}),
      ),
      const SizedBox(height: 16),
      _PasswordInputSection(
        controller: _passwordController,
        obscurePassword: _obscurePassword,
        onChanged: () => setState(() {}),
        onTogglePassword: () =>
            setState(() => _obscurePassword = !_obscurePassword),
      ),
      const SizedBox(height: 12),
      _LoginFormOptions(
        rememberMe: _rememberMe,
        onRememberMeChanged: (v) => setState(() => _rememberMe = v ?? false),
      ),
      const SizedBox(height: 24),
      LoginSubmitButton(
        isLoading: ref.watch(authStateProvider),
        isEnabled: canSubmit,
        onPressed: _handleLogin,
      ),
      const SizedBox(height: 16),
      const LoginFooter(),
    ];
  }
}
