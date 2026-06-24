import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import 'suggestion_chip.dart';

class SuggestionChipsRow extends StatelessWidget {
  final Function(String) onSuggestionTap;

  const SuggestionChipsRow({super.key, required this.onSuggestionTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onSuggestionTap(AppStrings.chatSuggestionSymptoms),
            child: const SuggestionChip(
              icon: Icons.medical_services_outlined,
              label: AppStrings.chatSuggestionSymptoms,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () =>
                onSuggestionTap(AppStrings.chatSuggestionDoctorSchedule),
            child: const SuggestionChip(
              icon: Icons.calendar_month_outlined,
              label: AppStrings.chatSuggestionDoctorSchedule,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => onSuggestionTap(AppStrings.chatSuggestionFacilities),
            child: const SuggestionChip(
              icon: Icons.local_hospital_outlined,
              label: AppStrings.chatSuggestionFacilities,
            ),
          ),
        ],
      ),
    );
  }
}
