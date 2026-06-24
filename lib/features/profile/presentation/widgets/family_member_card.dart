import '../../../../core/constants/app_strings.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import 'family_member_card_widgets.dart';

part 'family_member_card_parts.dart';

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
        color: isPrimary ? AppColors.primaryLight.withValues(alpha: 0.5) : AppColors.backgroundWhite.withValues(alpha: 0.85),
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
            color: AppColors.transparent,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    FamilyMemberAvatar(name: name, isPrimary: isPrimary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FamilyMemberHeader(name: name, isPrimary: isPrimary, relation: relation),
                          const SizedBox(height: 12),
                          Container(height: 1, color: AppColors.textGrey.withValues(alpha: 0.1)),
                          const SizedBox(height: 12),
                          _FamilyMemberDetails(dob: dob, gender: gender),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!isPrimary && id != null) FamilyMemberMenu(id: id!),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
