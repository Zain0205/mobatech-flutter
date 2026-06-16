import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../providers/profile_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class FamilyMembersScreen extends ConsumerWidget {
  const FamilyMembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: AppBar(
        title: const Text('Anggota Keluarga', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
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
            child: profileAsync.when(
              data: (user) {
                if (user == null) return const Center(child: Text('Data tidak ditemukan'));
                
                final familyList = user.familyMembers ?? [];
                
                return ListView(
                  padding: const EdgeInsets.all(24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildFamilyMemberCard(
                      context, ref,
                      name: user.fullName,
                      relation: 'Pemilik Akun',
                      isPrimary: true,
                      email: user.email,
                      phone: user.phone,
                      dob: user.dob,
                      gender: user.gender,
                    ),
                    const SizedBox(height: 16),
                    ...familyList.map((member) {
                      final m = member as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildFamilyMemberCard(
                          context, ref,
                          name: m['full_name'] ?? 'Tanpa Nama',
                          relation: m['relationship'] ?? 'Keluarga',
                          isPrimary: false,
                          id: m['ID'],
                          dob: m['date_of_birth'],
                          gender: m['gender'],
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text(ErrorHandler.getMessage(e))),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMemberModal(context, ref),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Anggota', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showAddMemberModal(BuildContext context, WidgetRef ref) {
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
                          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
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
                              ScaffoldMessenger.of(context).hideCurrentSnackBar(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⚠️ Harap lengkapi semua data terlebih dahulu', style: TextStyle(color: Colors.white)), backgroundColor: Colors.orange));
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
                                ScaffoldMessenger.of(context).hideCurrentSnackBar(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Row(children: [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 8), Text('Anggota keluarga berhasil ditambahkan!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
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
            color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
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
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
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
              hintStyle: TextStyle(color: AppColors.textGrey.withOpacity(0.5), fontSize: 13, fontWeight: FontWeight.normal),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyMemberCard(
    BuildContext context, 
    WidgetRef ref, {
    required String name, 
    required String relation, 
    required bool isPrimary, 
    int? id,
    String? dob,
    String? gender,
    String? email,
    String? phone,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primaryLight.withOpacity(0.5) : Colors.white.withOpacity(0.85),
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
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: isPrimary ? AppColors.primary : AppColors.textGrey.withOpacity(0.2),
                      child: Text(
                        name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 24, 
                          fontWeight: FontWeight.bold, 
                          color: isPrimary ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isPrimary)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text('Utama', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: isPrimary ? AppColors.primary : AppColors.primaryLight.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
                            child: Text(relation, style: TextStyle(color: isPrimary ? Colors.white : AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 12),
                          Container(height: 1, color: Colors.grey.withOpacity(0.1)),
                          const SizedBox(height: 12),
                          if (isPrimary) ...[
                            _buildDetailRow(Icons.cake_outlined, _formatDate(dob ?? '-')),
                            const SizedBox(height: 6),
                            _buildDetailRow(
                              gender?.toLowerCase() == 'perempuan' ? Icons.female : Icons.male, 
                              gender ?? '-',
                            ),
                          ] else ...[
                            _buildDetailRow(Icons.cake_outlined, _formatDate(dob ?? '-')),
                            const SizedBox(height: 6),
                            _buildDetailRow(
                              gender?.toLowerCase() == 'perempuan' ? Icons.female : Icons.male, 
                              gender ?? '-',
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!isPrimary && id != null)
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: AppColors.iconGrey),
                        color: Colors.white,
                        onSelected: (value) async {
                          if (value == 'delete') {
                            try {
                              await ref.read(authStateProvider.notifier).deleteFamilyMember(id);
                              ref.invalidate(userProfileProvider);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Row(children: [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 8), Text('Anggota keluarga berhasil dihapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ErrorHandler.getMessage(e), style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
                              }
                            }
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Text('Hapus', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
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

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 13, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr == '-' || dateStr.isEmpty) return dateStr;
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
        final monthIdx = int.tryParse(parts[1]) ?? 1;
        return '${parts[2]} ${months[monthIdx - 1]} ${parts[0]}';
      }
    } catch (_) {}
    return dateStr;
  }
}
