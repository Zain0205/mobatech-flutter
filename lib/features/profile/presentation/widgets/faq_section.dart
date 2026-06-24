import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'q': 'Bagaimana cara membatalkan janji temu?',
        'a':
            'Anda dapat membatalkan janji temu melalui menu Jadwal di Halaman Utama paling lambat 2 jam sebelum waktu praktek.',
      },
      {
        'q': 'Di mana saya bisa melihat hasil laboratorium?',
        'a':
            'Hasil laboratorium dapat dilihat di menu Data Rekam Medis pada halaman Profil setelah dokter menerbitkan hasil tersebut.',
      },
      {
        'q': 'Apakah aplikasi ini gratis?',
        'a':
            'Ya, aplikasi ini sepenuhnya gratis untuk diunduh dan digunakan. Namun untuk beberapa layanan medis tetap dikenakan biaya sesuai prosedur.',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: AppColors.transparent,
            child: Column(
              children: faqs.asMap().entries.map((entry) {
                final idx = entry.key;
                final faq = entry.value;
                return Column(
                  children: [
                    Theme(
                      data: ThemeData(dividerColor: AppColors.transparent),
                      child: ExpansionTile(
                        iconColor: AppColors.primary,
                        collapsedIconColor: AppColors.iconGrey,
                        title: Text(
                          faq['q']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                            fontSize: 14,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Text(
                              faq['a']!,
                              style: const TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (idx < faqs.length - 1)
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
