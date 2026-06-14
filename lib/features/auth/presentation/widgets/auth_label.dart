import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AuthLabel extends StatelessWidget {
  final String text;

  const AuthLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          children: const [
            TextSpan(
              text: '*',
              style: TextStyle(color: AppColors.errorRed),
            ),
          ],
        ),
      ),
    );
  }
}
