import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../providers/appointment_provider.dart';

class DoctorDetailScreen extends ConsumerStatefulWidget {
  final int doctorId;

  const DoctorDetailScreen({super.key, required this.doctorId});

  @override
  ConsumerState<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends ConsumerState<DoctorDetailScreen> {
  int? _selectedScheduleId;
  final TextEditingController _symptomsController = TextEditingController();
  bool _isBooking = false;

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
  }

  void _bookAppointment() async {
    if (_selectedScheduleId == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jadwal terlebih dahulu')),
      );
      return;
    }
    if (_symptomsController.text.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi keluhan terlebih dahulu')),
      );
      return;
    }

    setState(() {
      _isBooking = true;
    });

    try {
      final repository = ref.read(appointmentRepositoryProvider);
      await repository.bookAppointment(_selectedScheduleId!, _symptomsController.text);
      if (mounted) {
        ref.invalidate(userAppointmentsProvider);
        ScaffoldMessenger.of(context).hideCurrentSnackBar(); ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Janji temu berhasil dibuat')),
        );
        Navigator.pop(context); // go back
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ErrorHandler.getMessage(e), style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBooking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorAsync = ref.watch(doctorDetailProvider(widget.doctorId));
    final schedulesAsync = ref.watch(doctorSchedulesProvider(widget.doctorId));

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: AppBar(
        title: const Text('Detail Dokter', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Opacity(
                    opacity: 0.4,
                    child: Image.asset('assets/header_logo.png', width: 220),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: child,
            ),
          );
        },
        child: doctorAsync.when(
          data: (doctor) {
            return Column(
            children: [
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      // 1. Doctor Profile & About Card
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: AppColors.shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: Colors.white.withOpacity(0.85),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: doctor.imageUrl.isNotEmpty
                                            ? Image.network(
                                                doctor.imageUrl.replaceAll('/svg', '/png').replaceAll('.svg', '.png'), 
                                                width: 80, 
                                                height: 100, 
                                                fit: BoxFit.cover,
                                                errorBuilder: (ctx, err, stack) => Image.asset('assets/doctor.png', width: 80, height: 100, fit: BoxFit.cover),
                                              )
                                            : Image.asset('assets/doctor.png', width: 80, height: 100, fit: BoxFit.cover),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(doctor.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                            const SizedBox(height: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                                              child: Text(doctor.specialization, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Divider(height: 1, color: AppColors.backgroundScreen),
                                  ),
                                  const Text('Tentang Dokter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                  const SizedBox(height: 8),
                                  Text(doctor.description, style: const TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.5)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // 2. Schedules Card
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: AppColors.shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: Colors.white.withOpacity(0.85),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Pilih Jadwal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                  const SizedBox(height: 16),
                                  schedulesAsync.when(
                                    data: (schedules) {
                                      if (schedules.isEmpty) {
                                        return const Center(child: Text('Tidak ada jadwal tersedia', style: TextStyle(color: AppColors.textGrey)));
                                      }
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: schedules.length,
                                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                                        itemBuilder: (context, index) {
                                          final schedule = schedules[index];
                                          final isSelected = _selectedScheduleId == schedule.id;
                                          final isAvailable = schedule.isAvailable && (schedule.quota - schedule.booked > 0);
                                          final dateStr = schedule.date != null ? '${schedule.date!.day}/${schedule.date!.month}/${schedule.date!.year}' : '';
                                          
                                          return GestureDetector(
                                            onTap: isAvailable ? () {
                                              setState(() {
                                                if (_selectedScheduleId == schedule.id) {
                                                  _selectedScheduleId = null; // Unclick feature
                                                } else {
                                                  _selectedScheduleId = schedule.id;
                                                }
                                              });
                                            } : null,
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderGrey),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: isSelected ? AppColors.primary : AppColors.backgroundScreen,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(Icons.calendar_month, color: isSelected ? Colors.white : AppColors.textGrey, size: 20),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('$dateStr • ${schedule.startTime} - ${schedule.endTime}', 
                                                          style: TextStyle(fontWeight: FontWeight.bold, color: isAvailable ? AppColors.textDark : AppColors.textGrey, fontSize: 14),
                                                        ),
                                                        const SizedBox(height: 4),
                                                        Text('Sisa kuota: ${schedule.quota - schedule.booked}', 
                                                          style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (!isAvailable)
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                                      child: const Text('Penuh', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                                                    )
                                                  else
                                                    Icon(
                                                      isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                                      color: isSelected ? AppColors.primary : AppColors.textLightGrey,
                                                    )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    loading: () => const CardSkeletonLoader(count: 3),
                                    error: (e, _) => Text(ErrorHandler.getMessage(e)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // 3. Symptoms Card
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: AppColors.shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: Colors.white.withOpacity(0.85),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Keluhan / Gejala', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                  const SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: AppColors.borderGrey.withOpacity(0.5)),
                                    ),
                                    child: TextField(
                                      controller: _symptomsController,
                                      maxLines: 4,
                                      decoration: const InputDecoration(
                                        hintText: 'Tuliskan secara singkat keluhan yang Anda alami...',
                                        hintStyle: TextStyle(color: AppColors.textLightGrey, fontSize: 14),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
              
              // Bottom Action Bar (Sticky)
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: AppColors.shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
                      ],
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isBooking ? null : _bookAppointment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                            elevation: 0,
                          ),
                          child: _isBooking
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Buat Janji Temu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: CardSkeletonLoader(count: 2),
          ),
          error: (e, stack) => Center(child: Text(ErrorHandler.getMessage(e))),
        ),
      ),
    );
  }
}
