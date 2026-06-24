import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmitted;
  final VoidCallback onAttachmentTap;

  const ChatTextField({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onAttachmentTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white85,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.grey20),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => onSubmitted(),
                  decoration: const InputDecoration(
                    hintText: AppStrings.chatInputHint,
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onAttachmentTap,
                child: const Icon(
                  Icons.attach_file,
                  color: AppColors.textGrey,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
