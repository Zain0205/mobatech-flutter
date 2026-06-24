import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/skeleton_loader.dart';

class ChatBubbleImage extends StatelessWidget {
  final String imagePath;

  const ChatBubbleImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(File(imagePath), fit: BoxFit.cover),
      ),
    );
  }
}

class ChatBubbleFile extends StatelessWidget {
  final String filePath;
  final bool isUser;

  const ChatBubbleFile({
    super.key,
    required this.filePath,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isUser ? AppColors.iconWhite30 : AppColors.borderGrey,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: isUser ? AppColors.backgroundWhite : AppColors.iconOrange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              filePath.split('/').last,
              style: TextStyle(
                color: isUser ? AppColors.backgroundWhite : AppColors.textDark,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubbleLoader extends StatelessWidget {
  const ChatBubbleLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonLoader(
          height: 14,
          width: 200,
          margin: const EdgeInsets.only(bottom: 8),
        ),
        SkeletonLoader(
          height: 14,
          width: 150,
          margin: const EdgeInsets.only(bottom: 8),
        ),
        SkeletonLoader(height: 14, width: 180),
      ],
    );
  }
}

class ChatBubbleText extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubbleText({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    if (isUser) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textWhite,
          height: 1.4,
          fontWeight: FontWeight.normal,
        ),
      );
    }
    return MarkdownBody(
      data: text,
      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(
          fontSize: 14,
          color: AppColors.textDark,
          height: 1.4,
          fontWeight: FontWeight.w500,
        ),
        pPadding: const EdgeInsets.only(bottom: 8),
        listBullet: const TextStyle(color: AppColors.textDark),
        listBulletPadding: const EdgeInsets.only(right: 8),
        strong: const TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
        blockSpacing: 12.0,
      ),
    );
  }
}
