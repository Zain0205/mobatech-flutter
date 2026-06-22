import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../providers/profile_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class FamilyMemberCard extends ConsumerWidget {
  final String name;
  final String relation;
  final bool isPrimary;
  final int? id;
  final String? dob;
  final String? gender;
  final String? email;
  final String? phone;

  const FamilyMemberCard({
    super.key,
    required this.name,
    required this.relation,
    required this.isPrimary,
    this.id,
    this.dob,
    this.gender,
    this.email,
    this.phone,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primaryLight.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
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
                      backgroundColor: isPrimary ? AppColors.primary : AppColors.textGrey.withValues(alpha: 0.2),
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
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
                            decoration: BoxDecoration(color: isPrimary ? AppColors.primary : AppColors.primaryLight.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(8)),
                            child: Text(relation, style: TextStyle(color: isPrimary ? Colors.white : AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 12),
                          Container(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
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
                              await ref.read(authStateProvider.notifier).deleteFamilyMember(id!);
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
