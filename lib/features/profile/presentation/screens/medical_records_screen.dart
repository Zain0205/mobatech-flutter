import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../appointment/providers/appointment_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class MedicalRecordsScreen extends ConsumerWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(userAppointmentsProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: AppBar(
        title: const Text('Data Rekam Medis', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
                  opacity: 0.4,
                  child: Image.asset('assets/header_logo.png', width: 220),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              children: [
                profileAsync.when(
                  data: (user) => user != null ? _buildSummaryCard(context, ref, user) : const SizedBox(),
                  loading: () => const SkeletonLoader(width: double.infinity, height: 160, borderRadius: 24),
                  error: (e, s) => const SizedBox(),
                ),
            const SizedBox(height: 24),
            const Text(
              'Riwayat Pemeriksaan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),
            appointmentsAsync.when(
              data: (appointments) {
                if (appointments.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Belum ada riwayat medis.', style: TextStyle(color: AppColors.textGrey)),
                    ),
                  );
                }
                // Urutkan dari yang terbaru (dengan null safety)
                final sorted = List.of(appointments)..sort((a, b) {
                  final dateA = a.schedule?.date ?? DateTime.now();
                  final dateB = b.schedule?.date ?? DateTime.now();
                  return dateB.compareTo(dateA);
                });
                return Column(
                  children: sorted.map((appt) {
                    final isDone = appt.status.toLowerCase() == 'completed';
                    final dateStr = appt.schedule?.date != null 
                        ? DateFormat('dd MMM yyyy').format(appt.schedule!.date ?? DateTime.now()) 
                        : '-';
                    final docSpec = appt.doctor?.specialization ?? 'Umum';
                    final docName = appt.doctor?.name ?? 'Dokter Tidak Diketahui';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildRecordCard(
                        date: dateStr,
                        type: 'Konsultasi $docSpec',
                        doctor: docName,
                        status: appt.status.toUpperCase(),
                        icon: Icons.medical_services_outlined,
                        color: isDone ? AppColors.primary : Colors.orange,
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Column(
                children: [
                  SkeletonLoader(width: double.infinity, height: 100, borderRadius: 20),
                  SizedBox(height: 16),
                  SkeletonLoader(width: double.infinity, height: 100, borderRadius: 20),
                ],
              ),
              error: (err, stack) => Center(child: Text(ErrorHandler.getMessage(err))),
            ),
          ],
        ),
       ),
      ),
     ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, WidgetRef ref, UserProfile user) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: AppColors.primaryLight.withOpacity(0.5),
            padding: const EdgeInsets.all(20),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Golongan Darah', style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: Text(user.bloodType ?? '-', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showEditMedicalDataModal(context, ref, user),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.edit, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildVitals('Tinggi', user.height != null ? '${user.height} cm' : '- cm'),
                  _buildVitals('Berat', user.weight != null ? '${user.weight} kg' : '- kg'),
                  _buildVitals('Alergi', user.allergies != null && user.allergies!.isNotEmpty ? user.allergies! : 'Tidak Ada'),
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildVitals(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildRecordCard({required String date, required String type, required String doctor, required String status, required IconData icon, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(date, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                              Text(status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(type, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                          const SizedBox(height: 4),
                          Text(doctor, style: const TextStyle(fontSize: 14, color: AppColors.textGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditMedicalDataModal(BuildContext context, WidgetRef ref, UserProfile user) {
    String selectedBloodType = ['A', 'B', 'AB', 'O', 'A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'].contains(user.bloodType) ? user.bloodType! : 'O';
    final heightController = TextEditingController(text: user.height?.toString() ?? '');
    final weightController = TextEditingController(text: user.weight?.toString() ?? '');
    final allergiesController = TextEditingController(text: user.allergies ?? '');
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Material(
                color: AppColors.backgroundScreen,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40, height: 4,
                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text('Perbarui Data Fisik', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      const SizedBox(height: 24),
                      
                      // Blood Type Dropdown
                      const Text('Golongan Darah', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedBloodType,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                            items: ['A', 'B', 'AB', 'O', 'A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-']
                                .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontWeight: FontWeight.w600))))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => selectedBloodType = val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Height & Weight Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildModalTextField('Tinggi (cm)', heightController, Icons.height, TextInputType.number),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildModalTextField('Berat (kg)', weightController, Icons.monitor_weight_outlined, TextInputType.number),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Allergies
                      _buildModalTextField('Alergi (Opsional)', allergiesController, Icons.warning_amber_rounded, TextInputType.text),
                      const SizedBox(height: 32),
                      
                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: isSaving ? null : () async {
                            setState(() => isSaving = true);
                            try {
                              await ref.read(authStateProvider.notifier).updateProfile(
                                user.fullName,
                                user.phone,
                                null, // image unchanged
                                bloodType: selectedBloodType,
                                height: int.tryParse(heightController.text.trim()),
                                weight: int.tryParse(weightController.text.trim()),
                                allergies: allergiesController.text.trim(),
                              );
                              ref.invalidate(userProfileProvider);
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).hideCurrentSnackBar(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Row(children: [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 8), Text('Data fisik berhasil diperbarui!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ErrorHandler.getMessage(e), style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
                              }
                            } finally {
                              setState(() => isSaving = false);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: isSaving
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalTextField(String label, TextEditingController controller, IconData icon, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: type,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.textGrey, size: 20),
              border: InputBorder.none,
              hintText: 'Masukkan ${label.split('(').first.trim()}',
              hintStyle: TextStyle(color: AppColors.textGrey.withOpacity(0.5), fontSize: 13, fontWeight: FontWeight.normal),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
