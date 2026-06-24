import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'chat_text_field.dart';

class ChatInputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmitted;
  final VoidCallback onAttachmentTap;

  const ChatInputRow({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onAttachmentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ChatTextField(
            controller: controller,
            onSubmitted: onSubmitted,
            onAttachmentTap: onAttachmentTap,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onSubmitted,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send, color: AppColors.textWhite, size: 20),
          ),
        ),
      ],
    );
  }
}
