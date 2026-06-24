part of 'add_family_member_modal.dart';

class _AddFamilyMemberModalContent extends StatefulWidget {
  final WidgetRef ref;
  const _AddFamilyMemberModalContent({required this.ref});

  @override
  State<_AddFamilyMemberModalContent> createState() => _AddFamilyMemberModalContentState();
}

class _AddFamilyMemberModalContentState extends State<_AddFamilyMemberModalContent> {
  final _nameController = TextEditingController();
  final _relationController = TextEditingController();
  final _dobController = TextEditingController();
  String _selectedGender = 'Laki-laki';
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_nameController.text.trim().isEmpty || _relationController.text.trim().isEmpty || _dobController.text.trim().isEmpty) {
      _showWarning(AppStrings.extHaraplengkapisemuadataterlebihdahulu);
      return;
    }
    setState(() => _isSaving = true);
    try {
      await widget.ref.read(authStateProvider.notifier).addFamilyMember({
        'full_name': _nameController.text.trim(),
        'relationship': _relationController.text.trim(),
        'date_of_birth': _dobController.text.trim(),
        'gender': _selectedGender,
      });
      widget.ref.invalidate(userProfileProvider);
      if (mounted) _onSuccess();
    } catch (e) {
      if (mounted) _onError(e);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showWarning(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    CustomSnackbar.showWarning(context, msg);
  }

  void _onSuccess() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    CustomSnackbar.showSuccess(context, AppStrings.extAnggotakeluargaberhasilditambahkan);
  }

  void _onError(dynamic error) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    CustomSnackbar.showError(context, ErrorHandler.getMessage(error));
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
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
    if (date != null && mounted) {
      setState(() {
        _dobController.text = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      });
    }
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
            children: _buildFormContent(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormContent() {
    return [
      Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textGrey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
      const SizedBox(height: 24),
      const Text(AppStrings.extTambahanggotakeluarga, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
      const SizedBox(height: 24),
      ModalTextField(label: 'Nama Lengkap', controller: _nameController, icon: Icons.person_outline, type: TextInputType.name),
      const SizedBox(height: 16),
      ModalTextField(label: 'Hubungan (Anak, Istri, Suami, dll)', controller: _relationController, icon: Icons.family_restroom, type: TextInputType.text),
      const SizedBox(height: 16),
      ModalTextField(label: 'Tanggal Lahir (YYYY-MM-DD)', controller: _dobController, icon: Icons.cake_outlined, type: TextInputType.datetime, readOnly: true, onTap: _pickDate),
      const SizedBox(height: 16),
      const Text(AppStrings.extJeniskelamin, style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(child: GenderOptionButton(text: 'Laki-laki', icon: Icons.male, isSelected: _selectedGender == 'Laki-laki', onTap: () => setState(() => _selectedGender = 'Laki-laki'))),
          const SizedBox(width: 16),
          Expanded(child: GenderOptionButton(text: 'Perempuan', icon: Icons.female, isSelected: _selectedGender == 'Perempuan', onTap: () => setState(() => _selectedGender = 'Perempuan'))),
        ],
      ),
      const SizedBox(height: 32),
      SaveFamilyMemberButton(isSaving: _isSaving, onPressed: _handleSave),
    ];
  }
}
