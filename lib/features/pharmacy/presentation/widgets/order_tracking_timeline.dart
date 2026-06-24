import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

part 'order_tracking_item.dart';

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
          ),
        ],
      ),
      child: Column(
        children: [
          _TimelineItem(
            title: 'Pesanan Masuk',
            description: 'Sistem telah menerima pesanan Anda.',
            time: '08:00',
            isCompleted: true,
            isLast: false,
          ),
          _TimelineItem(
            title: 'Sedang Diproses',
            description: 'Apoteker sedang menyiapkan pesanan Anda.',
            time: isProcessing || isReady || isCompleted ? '08:30' : '-',
            isCompleted: isProcessing || isReady || isCompleted,
            isLast: false,
          ),
          _TimelineItem(
            title: 'Siap Diambil/Dikirim',
            description:
                'Obat siap diambil di konter atau sedang diantar kurir.',
            time: isReady || isCompleted ? '10:00' : '-',
            isCompleted: isReady || isCompleted,
            isLast: false,
          ),
          _TimelineItem(
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
}

