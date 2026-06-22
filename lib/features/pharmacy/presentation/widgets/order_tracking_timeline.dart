import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class OrderTrackingTimeline extends StatelessWidget {
  final bool isProcessing;
  final bool isReady;
  final bool isCompleted;

  const OrderTrackingTimeline({
    super.key,
    required this.isProcessing,
    required this.isReady,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          _buildTimelineItem(
            title: 'Pesanan Masuk',
            description: 'Sistem telah menerima pesanan Anda.',
            time: '08:00',
            isCompleted: true,
            isLast: false,
          ),
          _buildTimelineItem(
            title: 'Sedang Diproses',
            description: 'Apoteker sedang menyiapkan pesanan Anda.',
            time: isProcessing || isReady || isCompleted ? '08:30' : '-',
            isCompleted: isProcessing || isReady || isCompleted,
            isLast: false,
          ),
          _buildTimelineItem(
            title: 'Siap Diambil/Dikirim',
            description: 'Obat siap diambil di konter atau sedang diantar kurir.',
            time: isReady || isCompleted ? '10:00' : '-',
            isCompleted: isReady || isCompleted,
            isLast: false,
          ),
          _buildTimelineItem(
            title: 'Selesai',
            description: 'Pesanan telah diterima pelanggan.',
            time: isCompleted ? 'Selesai' : '-',
            isCompleted: isCompleted,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String description,
    required String time,
    required bool isCompleted,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : AppColors.backgroundLightGrey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? AppColors.primary : AppColors.borderGrey,
                  width: 2,
                ),
              ),
              child: isCompleted ? const Icon(Icons.check, size: 16, color: AppColors.textWhite) : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: isCompleted ? AppColors.primary : AppColors.dividerGrey,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isCompleted ? AppColors.textDark : AppColors.textGrey,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: isCompleted ? AppColors.textGrey : AppColors.textLightGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: isCompleted ? AppColors.textGrey : AppColors.textLightGrey,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
