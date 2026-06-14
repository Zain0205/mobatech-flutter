import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/doctor.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback? onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: doctor.imageUrl.isNotEmpty
                  ? Image.network(
                      doctor.imageUrl.replaceAll('/svg', '/png').replaceAll('.svg', '.png'),
                      width: 80,
                      height: 100,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    doctor.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.person_outline, doctor.specialization),
                  const SizedBox(height: 4),
                  _buildInfoRow(Icons.phone_outlined, doctor.contactInfo),
                  const SizedBox(height: 4),
                  if (doctor.isActive) _buildInfoRow(Icons.check_circle_outline, 'Available', color: Colors.green)
                  else _buildInfoRow(Icons.cancel_outlined, 'Unavailable', color: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Image.asset(
      'assets/doctor.png',
      width: 80,
      height: 100,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color color = AppColors.textDark}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }
}
