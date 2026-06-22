import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../providers/appointment_provider.dart';
import '../widgets/doctor_detail_content.dart';
import '../widgets/doctor_detail_app_bar.dart';

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
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jadwal terlebih dahulu')),
      );
      return;
    }
    if (_symptomsController.text.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi keluhan terlebih dahulu')),
      );
      return;
    }

    setState(() {
      _isBooking = true;
    });

    try {
      final repository = ref.read(appointmentRepositoryProvider);
      await repository.bookAppointment(
        _selectedScheduleId!,
        _symptomsController.text,
      );
      if (mounted) {
        ref.invalidate(userAppointmentsProvider);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Janji temu berhasil dibuat')),
        );
        Navigator.pop(context); // go back
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ErrorHandler.getMessage(e),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
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
      appBar: const DoctorDetailAppBar(),
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
            return DoctorDetailContent(
              doctor: doctor,
              schedulesAsync: schedulesAsync,
              selectedScheduleId: _selectedScheduleId,
              onScheduleSelected: (id) => setState(() => _selectedScheduleId = id),
              symptomsController: _symptomsController,
              isBooking: _isBooking,
              onBook: _bookAppointment,
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
