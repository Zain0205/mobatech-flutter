import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import 'edit_medical_fields.dart';

part 'edit_medical_data_modal_parts.dart';

void showEditMedicalDataModal(BuildContext context, WidgetRef ref, dynamic user) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.transparent,
    isScrollControlled: true,
    builder: (context) => _EditMedicalDataModalContent(user: user, ref: ref),
  );
}

class _EditMedicalDataModalContent extends StatefulWidget {
  final dynamic user;
  final WidgetRef ref;

  const _EditMedicalDataModalContent({required this.user, required this.ref});

  @override
  State<_EditMedicalDataModalContent> createState() => _EditMedicalDataModalContentState();
}

class _EditMedicalDataModalContentState extends State<_EditMedicalDataModalContent> {
  late String _selectedBloodType;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _allergiesController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final validTypes = ['A', 'B', 'AB', 'O', 'A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'];
    _selectedBloodType = validTypes.contains(widget.user.bloodType) ? widget.user.bloodType! : 'O';
    _heightController = TextEditingController(text: widget.user.height?.toString() ?? '');
    _weightController = TextEditingController(text: widget.user.weight?.toString() ?? '');
    _allergiesController = TextEditingController(text: widget.user.allergies ?? '');
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    try {
      await widget.ref.read(authStateProvider.notifier).updateProfile(
            widget.user.fullName,
            widget.user.phone,
            null,
            bloodType: _selectedBloodType,
            height: int.tryParse(_heightController.text.trim()),
            weight: int.tryParse(_weightController.text.trim()),
            allergies: _allergiesController.text.trim(),
          );
      widget.ref.invalidate(userProfileProvider);
      if (mounted) _onSuccess();
    } catch (e) {
      if (mounted) _onError(e);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _onSuccess() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    CustomSnackbar.showSuccess(context, AppStrings.extDatafisikberhasildiperbarui);
  }

  void _onError(dynamic error) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    CustomSnackbar.showError(context, ErrorHandler.getMessage(error));
  }

  @override
  Widget build(BuildContext context) {
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
            children: _buildContent(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    return [
      Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textGrey.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
      const SizedBox(height: 24),
      const Text(
        AppStrings.extPerbaruidatafisik,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
      ),
      const SizedBox(height: 24),
      _BloodTypeDropdown(
        value: _selectedBloodType,
        onChanged: (val) => val != null ? setState(() => _selectedBloodType = val) : null,
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(child: MedicalTextField(label: 'Tinggi (cm)', controller: _heightController, icon: Icons.height, type: TextInputType.number)),
          const SizedBox(width: 16),
          Expanded(child: MedicalTextField(label: 'Berat (kg)', controller: _weightController, icon: Icons.monitor_weight_outlined, type: TextInputType.number)),
        ],
      ),
      const SizedBox(height: 16),
      MedicalTextField(label: 'Alergi (Opsional)', controller: _allergiesController, icon: Icons.warning_amber_rounded, type: TextInputType.text),
      const SizedBox(height: 32),
      _SaveButton(isSaving: _isSaving, onPressed: _handleSave),
    ];
  }
}
