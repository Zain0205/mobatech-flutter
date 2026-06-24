import 'package:flutter/material.dart';
import 'profile_avatar_picker.dart';
import 'edit_profile_widgets.dart';

class EditProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String? imagePath;
  final VoidCallback onPickImage;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController dobController;
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;
  final BuildContext parentContext;
  final VoidCallback onDateSelected;
  final bool isLoading;
  final VoidCallback onSaveProfile;

  const EditProfileForm({
    super.key,
    required this.formKey,
    required this.imagePath,
    required this.onPickImage,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.dobController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.parentContext,
    required this.onDateSelected,
    required this.isLoading,
    required this.onSaveProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileAvatarPicker(imagePath: imagePath, onPickImage: onPickImage),
          const SizedBox(height: 32),
          EditProfileFormFields(
            fullNameController: fullNameController,
            emailController: emailController,
            phoneController: phoneController,
            dobController: dobController,
            selectedGender: selectedGender,
            onGenderChanged: onGenderChanged,
            parentContext: parentContext,
            onDateSelected: onDateSelected,
          ),
          const SizedBox(height: 48),
          EditProfileSubmitButton(
            isLoading: isLoading,
            onPressed: onSaveProfile,
          ),
        ],
      ),
    );
  }
}
