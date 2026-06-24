import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'chat_bubble_parts.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isUser;
  final bool isLoading;
  final String? imagePath;
  final String? filePath;

  const ChatBubble({
    super.key,
    required this.text,
    required this.time,
    this.isUser = false,
    this.isLoading = false,
    this.imagePath,
    this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isUser) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
        ] else
          const SizedBox(width: 48),

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: isUser
                      ? AppColors.primary.withValues(alpha: 0.85)
                      : AppColors.backgroundWhite.withValues(alpha: 0.85),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imagePath != null)
                        ChatBubbleImage(imagePath: imagePath!),
                      if (filePath != null)
                        ChatBubbleFile(filePath: filePath!, isUser: isUser),
                      if (isLoading)
                        const ChatBubbleLoader()
                      else
                        ChatBubbleText(text: text, isUser: isUser),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          time,
                          style: TextStyle(
                            fontSize: 10,
                            color: isUser
                                ? AppColors.textWhite
                                : AppColors.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        if (isUser) ...[
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.borderGrey,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/doctor.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ] else
          const SizedBox(width: 48),
      ],
    );
  }
}
