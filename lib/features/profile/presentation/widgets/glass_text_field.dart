import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class GlassTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;
  final bool readOnly;
  final String? prefixText;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final Function(String)? onChanged;

  const GlassTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.prefixText,
    this.formatters,
    this.validator,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? Colors.white.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
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
            onChanged: onChanged ?? (val) {
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
              hintStyle: TextStyle(color: AppColors.textGrey.withValues(alpha: 0.5), fontSize: 13, fontWeight: FontWeight.normal),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
      ),
    );
  }
}
