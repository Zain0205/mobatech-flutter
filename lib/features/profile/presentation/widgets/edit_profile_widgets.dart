import '../../../../core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/validators.dart';
import 'glass_text_field.dart';
import 'gender_selection.dart';

part 'edit_profile_widgets_parts.dart';

class EditProfileFormFields extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController dobController;
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;
  final BuildContext parentContext;
  final VoidCallback onDateSelected;

  const EditProfileFormFields({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.dobController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.parentContext,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlassTextField(label: 'Nama Lengkap', controller: fullNameController, icon: Icons.person_outline, validator: (v) => Validators.validateName(v, 'Nama lengkap')),
        const SizedBox(height: 16),
        GlassTextField(label: 'Email', controller: emailController, icon: Icons.email_outlined, readOnly: true),
        const SizedBox(height: 16),
        GlassTextField(
          label: 'Nomor Telepon',
          controller: phoneController,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          prefixText: '+62 ',
          validator: Validators.validatePhone,
          formatters: [PhonePrefixFormatter()],
        ),
        const SizedBox(height: 16),
        GlassTextField(
          label: 'Tanggal Lahir (YYYY-MM-DD)',
          controller: dobController,
          icon: Icons.cake_outlined,
          keyboardType: TextInputType.datetime,
          readOnly: true,
          onTap: () => _pickDate(context),
        ),
        const SizedBox(height: 16),
        GenderSelection(selectedGender: selectedGender, onChanged: onGenderChanged),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: parentContext,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary, onPrimary: AppColors.backgroundWhite, onSurface: AppColors.textDark),
        ),
        child: child!,
      ),
    );
    if (date != null) {
      dobController.text = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      onDateSelected();
    }
  }
}
