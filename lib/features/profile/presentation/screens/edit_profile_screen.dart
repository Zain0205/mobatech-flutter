import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

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
        if (p.startsWith('+62')) p = p.substring(3);
        else if (p.startsWith('62')) p = p.substring(2);
        else if (p.startsWith('0')) p = p.substring(1);
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
      setState(() {
        _imagePath = pickedFile.path;
      });
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
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset('assets/header_logo.png', width: 220),
                ),
              ),
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
            child: Transform.translate(
              offset: Offset(0, 15 * (1 - value)),
              child: child,
            ),
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
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 3),
                      image: _imagePath != null
                          ? DecorationImage(
                              image: _imagePath!.startsWith('http') ? NetworkImage(_imagePath!) as ImageProvider : FileImage(File(_imagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _imagePath == null
                        ? const Icon(Icons.person, size: 50, color: AppColors.primary)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildGlassTextField(
              'Nama Lengkap', 
              _fullNameController, 
              Icons.person_outline,
              validator: (v) => Validators.validateRequired(v, 'Nama lengkap'),
            ),
            const SizedBox(height: 16),
            _buildGlassTextField('Email', _emailController, Icons.email_outlined, readOnly: true),
            const SizedBox(height: 16),
            _buildGlassTextField(
              'Nomor Telepon', 
              _phoneController, 
              Icons.phone_outlined, 
              keyboardType: TextInputType.phone,
              prefixText: '+62 ',
              formatters: [
                PhonePrefixFormatter(),
              ],
            ),
            const SizedBox(height: 16),
            _buildGlassTextField(
              'Tanggal Lahir (YYYY-MM-DD)', 
              _dobController, 
              Icons.cake_outlined, 
              keyboardType: TextInputType.datetime,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.primary,
                          onPrimary: Colors.white,
                          onSurface: AppColors.textDark,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() {
                    _dobController.text = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildGenderSelection(),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  shadowColor: AppColors.primary.withOpacity(0.4),
                ),
                child: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildGlassTextField(
    String label, 
    TextEditingController controller, 
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    String? prefixText,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? Colors.white.withOpacity(0.4) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            inputFormatters: formatters,
            validator: validator,
            onTap: onTap,
            onChanged: (val) {
              if (label == 'Nomor Telepon') {
                if (val.startsWith('62')) {
                  controller.text = val.substring(2);
                  controller.selection = TextSelection.collapsed(offset: controller.text.length);
                } else if (val.startsWith('0')) {
                  controller.text = val.substring(1);
                  controller.selection = TextSelection.collapsed(offset: controller.text.length);
                }
              }
            },
            style: TextStyle(fontWeight: FontWeight.w600, color: readOnly ? AppColors.textGrey : AppColors.textDark),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
              prefixIcon: Icon(icon, color: AppColors.textGrey),
              prefixText: prefixText,
              prefixStyle: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 14),
              border: InputBorder.none,
              hintText: 'Masukkan ${label.toLowerCase()}',
              hintStyle: TextStyle(color: AppColors.textGrey.withOpacity(0.5), fontSize: 13, fontWeight: FontWeight.normal),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
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
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
              : [BoxShadow(color: AppColors.primary.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
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
