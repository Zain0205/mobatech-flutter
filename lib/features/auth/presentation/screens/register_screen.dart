import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_label.dart';
import '../widgets/phone_text_field.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Register',
          style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthLabel(text: 'Full Name '),
                  const SizedBox(height: 8),
                  AuthTextField(hint: 'Enter full name', controller: _nameController, onChanged: (v) => setState(() {})),
                  const SizedBox(height: 20),
                  
                  const AuthLabel(text: 'Email '),
                  const SizedBox(height: 8),
                  AuthTextField(hint: 'example@gmail.com', controller: _emailController, onChanged: (v) => setState(() {})),
                  const SizedBox(height: 20),
                  
                  const AuthLabel(text: 'Phone Number '),
                  const SizedBox(height: 8),
                  PhoneTextField(controller: _phoneController),
                  const SizedBox(height: 20),
                  
                  const AuthLabel(text: 'Password '),
                  const SizedBox(height: 8),
                  AuthTextField(
                    hint: 'Enter your password',
                    isPassword: true,
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onChanged: (v) => setState(() {}),
                    onTogglePassword: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordValidations(),
                  const SizedBox(height: 20),
                  
                  const AuthLabel(text: 'Confirmation Password '),
                  const SizedBox(height: 8),
                  AuthTextField(
                    hint: 'Enter your password',
                    isPassword: true,
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    onChanged: (v) => setState(() {}),
                    onTogglePassword: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: ref.watch(authStateProvider) ? null : () async {
                  if (_passwordController.text != _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
                    return;
                  }
                  try {
                    await ref.read(authStateProvider.notifier).register(
                      _nameController.text,
                      _emailController.text,
                      '+62${_phoneController.text}',
                      _passwordController.text,
                    );
                    if (context.mounted) {
                      context.go('/home');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textWhite,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 0,
                ),
                child: ref.watch(authStateProvider) 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text(
                      'Next',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordValidations() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        _validationItem('At least 8 characters'),
        _validationItem('Uppercase'),
        _validationItem('Lowercase'),
        _validationItem('Number'),
      ],
    );
  }

  Widget _validationItem(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_outline, size: 12, color: AppColors.textDark),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 10, color: AppColors.textGrey),
        ),
      ],
    );
  }
}
