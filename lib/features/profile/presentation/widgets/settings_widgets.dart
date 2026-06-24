import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/theme/app_colors.dart';

part 'settings_widgets_parts.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textGrey,
      ),
    );
  }
}

class SettingsContainer extends StatelessWidget {
  final List<Widget> children;

  const SettingsContainer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textGrey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(children: _buildChildren()),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    return children.asMap().entries.map((entry) {
      final idx = entry.key;
      final child = entry.value;
      if (idx < children.length - 1) {
        return Column(children: [child, const Divider(height: 1, indent: 16, endIndent: 16)]);
      }
      return child;
    }).toList();
  }
}
