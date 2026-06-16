import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/error_handler.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_label.dart';

import '../providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../appointment/providers/appointment_provider.dart';
import '../../../services/presentation/providers/service_provider.dart';
import '../../../chatbot/presentation/providers/chat_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isButtonEnabled = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.48,
            child: Container(
               color: AppColors.primaryLight,
               child: Stack(
                 children: [
                   Positioned(
                     bottom: -50,
                     right: -80,
                     child: Container(
                       width: size.width * 1.2,
                       height: size.width * 0.6,
                       decoration: const BoxDecoration(
                         color: AppColors.backgroundWave,
                         borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(300),
                           bottomLeft: Radius.circular(50),
                         ),
                       ),
                     ),
                   ),
                   Positioned(
                     top: 150,
                     right: 40,
                     child: Image.asset('assets/plus.png', width: 32),
                   ),
                   Positioned(
                     top: 60,
                     left: 24,
                     child: Image.asset('assets/hermina_logo.png', width: 50),
                   ),
                   Align(
                     alignment: Alignment.bottomCenter,
                     child: Padding(
                       padding: const EdgeInsets.only(bottom: 20),
                       child: Image.asset('assets/doctor.png', height: 260),
                     ),
                   ),
                 ],
               ),
            ),
          ),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.55,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Halo, Selamat Datang 👋',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Masuk ke Hermina Mobile Apps',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    const AuthLabel(text: 'Email '),
                    const SizedBox(height: 8),
                    AuthTextField(
                      hint: 'contoh@email.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                      onChanged: (v) => setState(() {}),
                    ),
                    const SizedBox(height: 20),
                    
                    const AuthLabel(text: 'Kata Sandi '),
                    const SizedBox(height: 8),
                    AuthTextField(
                      hint: 'contoh123',
                      isPassword: true,
                      obscureText: _obscurePassword,
                      controller: _passwordController,
                      validator: Validators.validatePassword,
                      onChanged: (v) => setState(() {}),
                      onTogglePassword: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                activeColor: AppColors.primary,
                                checkColor: AppColors.textWhite,
                                side: const BorderSide(color: AppColors.textGrey, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Ingat saya',
                              style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Lupa kata sandi?',
                            style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: (isButtonEnabled && !ref.watch(authStateProvider)) ? () async {
                          if (!_formKey.currentState!.validate()) return;
                          try {
                            await ref.read(authStateProvider.notifier).login(
                              _emailController.text,
                              _passwordController.text,
                            );
                            ref.invalidate(userProfileProvider);
                            ref.invalidate(userAppointmentsProvider);
                            ref.invalidate(servicesProvider);
                            ref.invalidate(chatSessionsProvider);
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
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.buttonDisabled,
                          foregroundColor: AppColors.textWhite,
                          disabledForegroundColor: AppColors.buttonDisabledText,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          elevation: 0,
                        ),
                        child: ref.watch(authStateProvider)
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text(
                              'Masuk',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Belum punya akun? ",
                          style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/register'),
                          child: const Text(
                            'Daftar',
                            style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
