import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class GenderSelection extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String> onChanged;

  const GenderSelection({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text('Jenis Kelamin', style: TextStyle(color: AppColors.textGrey, fontSize: 13, fontWeight: FontWeight.w600)),
        ),
        Row(
          children: [
            Expanded(child: _buildGenderCard('Laki-laki', Icons.male)),
            const SizedBox(width: 16),
            Expanded(child: _buildGenderCard('Perempuan', Icons.female)),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderCard(String gender, IconData icon) {
    final isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () => onChanged(gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))]
              : [BoxShadow(color: AppColors.primary.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : AppColors.textGrey, size: 20),
            const SizedBox(width: 8),
            Text(
              gender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? Colors.white : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
