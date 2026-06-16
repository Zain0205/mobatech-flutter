import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/error_handler.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_label.dart';
import '../widgets/phone_text_field.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();
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
          'Daftar Akun',
          style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthLabel(text: 'Nama Lengkap '),
                  const SizedBox(height: 8),
                  AuthTextField(
                    hint: 'Masukkan nama lengkap', 
                    controller: _nameController, 
                    validator: (v) => Validators.validateRequired(v, 'Nama lengkap'),
                    onChanged: (v) => setState(() {})
                  ),
                  const SizedBox(height: 20),
                  
                  const AuthLabel(text: 'Email '),
                  const SizedBox(height: 8),
                  AuthTextField(
                    hint: 'contoh@email.com', 
                    controller: _emailController, 
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                    onChanged: (v) => setState(() {})
                  ),
                  const SizedBox(height: 20),
                  
                  const AuthLabel(text: 'Nomor Telepon '),
                  const SizedBox(height: 8),
                  PhoneTextField(controller: _phoneController),
                  const SizedBox(height: 20),
                  
                  const AuthLabel(text: 'Kata Sandi '),
                  const SizedBox(height: 8),
                  AuthTextField(
                    hint: 'Masukkan kata sandi',
                    isPassword: true,
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: Validators.validatePassword,
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
                  
                  const AuthLabel(text: 'Konfirmasi Kata Sandi '),
                  const SizedBox(height: 8),
                  AuthTextField(
                    hint: 'Masukkan ulang kata sandi',
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
        ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: ref.watch(authStateProvider) ? null : () async {
                  if (!_formKey.currentState!.validate()) return;
                  if (_phoneController.text.length < 8) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomor telepon tidak valid', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
                    return;
                  }
                  final confirmError = Validators.validateConfirmPassword(_confirmPasswordController.text, _passwordController.text);
                  if (confirmError != null) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(confirmError, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
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
                    if (context.mounted) {
                      context.go('/home');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(ErrorHandler.getMessage(e), style: const TextStyle(color: Colors.white)),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
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
                      'Daftar',
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
        _validationItem('Minimal 8 karakter'),
        _validationItem('Huruf Besar'),
        _validationItem('Huruf Kecil'),
        _validationItem('Angka'),
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
