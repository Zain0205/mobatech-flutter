import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

void showEditMedicalDataModal(BuildContext context, WidgetRef ref, dynamic user) {
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
                        decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
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
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
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
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: TextField(
          controller: controller,
          keyboardType: type,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textGrey, size: 20),
            border: InputBorder.none,
            hintText: 'Masukkan ${label.split('(').first.trim()}',
            hintStyle: TextStyle(color: AppColors.textGrey.withValues(alpha: 0.5), fontSize: 13, fontWeight: FontWeight.normal),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    ],
  );
}
