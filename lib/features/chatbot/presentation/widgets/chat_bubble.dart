import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isUser;
  final bool isLoading;

  const ChatBubble({
    super.key,
    required this.text,
    required this.time,
    this.isUser = false,
    this.isLoading = false,
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUser ? AppColors.primary : AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoading)
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 14, width: 200, color: Colors.white, margin: const EdgeInsets.only(bottom: 8)),
                        Container(height: 14, width: 150, color: Colors.white, margin: const EdgeInsets.only(bottom: 8)),
                        Container(height: 14, width: 180, color: Colors.white),
                      ],
                    ),
                  )
                else
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14, 
                      color: isUser ? AppColors.textWhite : AppColors.textDark, 
                      height: 1.4, 
                      fontWeight: isUser ? FontWeight.normal : FontWeight.w500
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
