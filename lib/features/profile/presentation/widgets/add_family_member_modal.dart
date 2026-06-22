import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../providers/profile_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

void showAddMemberModal(BuildContext context, WidgetRef ref) {
  final nameController = TextEditingController();
  final relationController = TextEditingController();
  final dobController = TextEditingController();
  String selectedGender = 'Laki-laki';
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
                    const Text('Tambah Anggota Keluarga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 24),
                    
                    _buildModalTextField('Nama Lengkap', nameController, Icons.person_outline, TextInputType.name),
                    const SizedBox(height: 16),
                    _buildModalTextField('Hubungan (Anak, Istri, Suami, dll)', relationController, Icons.family_restroom, TextInputType.text),
                    const SizedBox(height: 16),
                    _buildModalTextField(
                      'Tanggal Lahir (YYYY-MM-DD)', 
                      dobController, 
                      Icons.cake_outlined, 
                      TextInputType.datetime,
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.primary,
                                  onPrimary: Colors.white,
                                  onSurface: AppColors.textDark,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (date != null) {
                          setState(() {
                            dobController.text = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    const Text('Jenis Kelamin', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGenderOption(
                            'Laki-laki', 
                            Icons.male, 
                            selectedGender == 'Laki-laki', 
                            () => setState(() => selectedGender = 'Laki-laki'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildGenderOption(
                            'Perempuan', 
                            Icons.female, 
                            selectedGender == 'Perempuan', 
                            () => setState(() => selectedGender = 'Perempuan'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: isSaving ? null : () async {
                          if (nameController.text.trim().isEmpty || relationController.text.trim().isEmpty || dobController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⚠️ Harap lengkapi semua data terlebih dahulu', style: TextStyle(color: Colors.white)), backgroundColor: Colors.orange));
                            return;
                          }
                          setState(() => isSaving = true);
                          try {
                            await ref.read(authStateProvider.notifier).addFamilyMember({
                              'full_name': nameController.text.trim(),
                              'relationship': relationController.text.trim(),
                              'date_of_birth': dobController.text.trim(),
                              'gender': selectedGender,
                            });
                            ref.invalidate(userProfileProvider);
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Row(children: [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 8), Text('Anggota keluarga berhasil ditambahkan!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ErrorHandler.getMessage(e), style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
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
                            : const Text('Simpan Anggota', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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

Widget _buildGenderOption(String text, IconData icon, bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))]
            : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.white : AppColors.textGrey, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isSelected ? Colors.white : AppColors.textDark,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildModalTextField(
  String label, 
  TextEditingController controller, 
  IconData icon, 
  TextInputType type, {
  bool readOnly = false,
  VoidCallback? onTap,
}) {
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
          readOnly: readOnly,
          onTap: onTap,
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
