import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/gender_selection.dart';
import '../widgets/profile_avatar_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedGender;
  final _formKey = GlobalKey<FormState>();
  
  String? _imagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  void _loadCurrentData() {
    final userAsync = ref.read(userProfileProvider);
    userAsync.whenData((user) {
      if (user != null) {
        _fullNameController.text = user.fullName;
        _emailController.text = user.email;
        String p = user.phone;
        if (p.startsWith('+62')) {
          p = p.substring(3);
        } else if (p.startsWith('62')) {
          p = p.substring(2);
        } else if (p.startsWith('0')) {
          p = p.substring(1);
        }
        _phoneController.text = p;
        _dobController.text = user.dob ?? '';
        setState(() {
          _selectedGender = user.gender;
          _imagePath = user.imagePath;
        });
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imagePath = pickedFile.path);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final userAsync = ref.read(userProfileProvider);
      final user = userAsync.value;

      String? pathForUpload = _imagePath;
      if (pathForUpload != null && pathForUpload.startsWith('http')) {
        pathForUpload = null;
      }

      await ref.read(authStateProvider.notifier).updateProfile(
        _fullNameController.text.trim(),
        '+62${_phoneController.text.trim()}',
        pathForUpload,
        bloodType: user?.bloodType,
        height: user?.height,
        weight: user?.weight,
        allergies: user?.allergies,
        dob: _dobController.text.trim(),
        gender: _selectedGender,
      );

      ref.invalidate(userProfileProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Row(children: [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 8), Text('Profil berhasil diperbarui!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ErrorHandler.getMessage(e), style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: AppBar(
        title: const Text('Ubah Profil', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(right: -20, top: -20, child: Opacity(opacity: 0.4, child: Image.asset('assets/header_logo.png', width: 220))),
            ],
          ),
        ),
      ),
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(offset: Offset(0, 15 * (1 - value)), child: child),
          );
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: ListView(
                padding: const EdgeInsets.all(24),
                physics: const BouncingScrollPhysics(),
                children: [
                  ProfileAvatarPicker(imagePath: _imagePath, onPickImage: _pickImage),
                  const SizedBox(height: 32),
                  GlassTextField(label: 'Nama Lengkap', controller: _fullNameController, icon: Icons.person_outline, validator: (v) => Validators.validateRequired(v, 'Nama lengkap')),
                  const SizedBox(height: 16),
                  GlassTextField(label: 'Email', controller: _emailController, icon: Icons.email_outlined, readOnly: true),
                  const SizedBox(height: 16),
                  GlassTextField(label: 'Nomor Telepon', controller: _phoneController, icon: Icons.phone_outlined, keyboardType: TextInputType.phone, prefixText: '+62 ', formatters: [PhonePrefixFormatter()]),
                  const SizedBox(height: 16),
                  GlassTextField(
                    label: 'Tanggal Lahir (YYYY-MM-DD)', 
                    controller: _dobController, 
                    icon: Icons.cake_outlined, 
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(context: context, initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)), firstDate: DateTime(1900), lastDate: DateTime.now(), builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary, onPrimary: Colors.white, onSurface: AppColors.textDark)), child: child!));
                      if (date != null) setState(() => _dobController.text = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}");
                    },
                  ),
                  const SizedBox(height: 16),
                  GenderSelection(selectedGender: _selectedGender, onChanged: (gender) => setState(() => _selectedGender = gender)),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 5, shadowColor: AppColors.primary.withValues(alpha: 0.4)),
                      child: _isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) : const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
