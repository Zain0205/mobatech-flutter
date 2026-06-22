import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Stack(
                children: [
                  // Top Green Header (Scrolls together with the page)
                  Container(
                    height: constraints.maxHeight * 0.48,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, Color(0xFF2E7D32)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -20,
                          right: -20,
                          child: Opacity(
                            opacity: 0.2,
                            child: Image.asset('assets/header_logo.png', width: 220),
                          ),
                        ),
                        Positioned(
                          top: 150,
                          right: 40,
                          child: Opacity(
                            opacity: 0.8,
                            child: Image.asset('assets/plus.png', width: 32),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.08),
                            child: Image.asset('assets/doctor.png', height: constraints.maxHeight * 0.35),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom White Form (Overlaps the green header)
                  Container(
                    margin: EdgeInsets.only(top: constraints.maxHeight * 0.42),
                    constraints: BoxConstraints(minHeight: constraints.maxHeight * 0.58),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSizes.borderRadiusCard),
                        topRight: Radius.circular(AppSizes.borderRadiusCard),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5)),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.loginGreeting,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                        SizedBox(height: 8),
                        Text(
                          AppStrings.loginSubtitle,
                          style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                        ),
                        SizedBox(height: 32),
                        LoginForm(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
