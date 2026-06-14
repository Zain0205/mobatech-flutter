import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AgendaCard extends StatelessWidget {
  const AgendaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 24, right: 24),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.agendaHeader,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'dr. Davin Rizky Parulian Silalahi Sp.B (K) Onk',
                          style: TextStyle(color: AppColors.textWhite, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderGrey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Spesialis Bedah Onkologi',
                          style: TextStyle(color: AppColors.textDark, fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/doctor.png', width: 70, height: 70, fit: BoxFit.cover, alignment: Alignment.topCenter),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.agendaBackground,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Senin, 11 Mei 2026 . 08.50', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                SizedBox(height: 4),
                Text('J-02 . HM-021322-002', style: TextStyle(fontSize: 13, color: AppColors.textDark)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
