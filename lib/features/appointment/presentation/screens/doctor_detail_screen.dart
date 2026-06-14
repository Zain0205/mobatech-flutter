import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jadwal terlebih dahulu')),
      );
      return;
    }
    if (_symptomsController.text.isEmpty) {
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
      await repository.bookAppointment(_selectedScheduleId!, _symptomsController.text);
      if (mounted) {
        ref.invalidate(userAppointmentsProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Janji temu berhasil dibuat')),
        );
        Navigator.pop(context); // go back
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat janji temu: $e')),
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
      appBar: AppBar(
        title: const Text('Detail Dokter'),
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.textDark,
      ),
      body: doctorAsync.when(
        data: (doctor) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: doctor.imageUrl.isNotEmpty
                          ? Image.network(
                              doctor.imageUrl.replaceAll('/svg', '/png').replaceAll('.svg', '.png'), 
                              width: 100, 
                              height: 120, 
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Image.asset('assets/doctor.png', width: 100, height: 120, fit: BoxFit.cover),
                            )
                          : Image.asset('assets/doctor.png', width: 100, height: 120, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctor.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(doctor.specialization, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(doctor.contactInfo, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Tentang Dokter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(doctor.description),
                const SizedBox(height: 24),
                const Text('Pilih Jadwal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                schedulesAsync.when(
                  data: (schedules) {
                    if (schedules.isEmpty) {
                      return const Text('Tidak ada jadwal tersedia');
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: schedules.length,
                      itemBuilder: (context, index) {
                        final schedule = schedules[index];
                        final isSelected = _selectedScheduleId == schedule.id;
                        final dateStr = schedule.date != null ? '${schedule.date!.day}/${schedule.date!.month}/${schedule.date!.year}' : '';
                        return ListTile(
                          title: Text('$dateStr - ${schedule.startTime} s/d ${schedule.endTime}'),
                          subtitle: Text('Sisa kuota: ${schedule.quota - schedule.booked}'),
                          trailing: schedule.isAvailable && (schedule.quota - schedule.booked > 0)
                              ? Radio<int>(
                                  value: schedule.id,
                                  groupValue: _selectedScheduleId,
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedScheduleId = val;
                                    });
                                  },
                                )
                              : const Text('Penuh/Tidak Tersedia', style: TextStyle(color: Colors.red)),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Gagal memuat jadwal: $e'),
                ),
                const SizedBox(height: 24),
                const Text('Keluhan / Gejala', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _symptomsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Tuliskan keluhan atau gejala yang dialami...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isBooking ? null : _bookAppointment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: _isBooking
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Buat Janji Temu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
