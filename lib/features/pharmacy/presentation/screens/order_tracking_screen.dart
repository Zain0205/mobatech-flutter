import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/mock_ui_providers.dart';
import '../widgets/order_tracking_header.dart';
import '../widgets/order_tracking_timeline.dart';

class OrderTrackingScreen extends StatelessWidget {
  final PharmacyOrderMock? order;

  const OrderTrackingScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    final orderTitle = order?.title ?? 'ORD-PH-20231015-001';
    final status = order?.status ?? 'Diproses';
    final statusLower = status.toLowerCase();

    bool isProcessing = statusLower.contains('proses') || statusLower.contains('verifying') || statusLower.contains('processing');
    bool isReady = statusLower.contains('ready') || statusLower.contains('dikirim');
    bool isCompleted = statusLower.contains('selesai') || statusLower.contains('completed');

    return Scaffold(
      backgroundColor: AppColors.backgroundLightGrey,
      appBar: AppBar(
        title: const Text('Detail Lacak Pesanan', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textWhite),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset('assets/header_logo.png', width: 220),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            OrderTrackingHeader(order: order, orderTitle: orderTitle, status: status),
            const SizedBox(height: 24),
            OrderTrackingTimeline(
              isProcessing: isProcessing,
              isReady: isReady,
              isCompleted: isCompleted,
            ),
          ],
        ),
      ),
    );
  }
}
