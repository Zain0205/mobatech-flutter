import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/skeleton_loader.dart';

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
            child: const Icon(Icons.smart_toy, color: AppColors.primary, size: 20),
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
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: isUser ? AppColors.primary.withValues(alpha: 0.85) : Colors.white.withValues(alpha: 0.85),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imagePath != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(imagePath!), fit: BoxFit.cover),
                    ),
                  ),
                if (filePath != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isUser ? Colors.white30 : AppColors.borderGrey),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.description, color: isUser ? Colors.white : Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(child: Text(filePath!.split('/').last, style: TextStyle(color: isUser ? Colors.white : AppColors.textDark, fontSize: 12))),
                      ],
                    ),
                  ),

                if (isLoading)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoader(height: 14, width: 200, margin: const EdgeInsets.only(bottom: 8)),
                      SkeletonLoader(height: 14, width: 150, margin: const EdgeInsets.only(bottom: 8)),
                      SkeletonLoader(height: 14, width: 180),
                    ],
                  )
                else if (text.isNotEmpty)
                  isUser 
                    ? Text(
                        text,
                        style: const TextStyle(
                          fontSize: 14, 
                          color: AppColors.textWhite, 
                          height: 1.4, 
                          fontWeight: FontWeight.normal
                        ),
                      )
                    : MarkdownBody(
                        data: text,
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(fontSize: 14, color: AppColors.textDark, height: 1.4, fontWeight: FontWeight.w500),
                          pPadding: const EdgeInsets.only(bottom: 8),
                          listBullet: const TextStyle(color: AppColors.textDark),
                          listBulletPadding: const EdgeInsets.only(right: 8),
                          strong: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
                          blockSpacing: 12.0,
                        ),
                      ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    time,
                    style: TextStyle(fontSize: 10, color: isUser ? AppColors.textWhite : AppColors.textGrey),
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
