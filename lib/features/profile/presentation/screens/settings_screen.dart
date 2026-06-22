import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifPush = true;
  bool _notifEmail = false;
  bool _faceId = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notifPush = prefs.getBool('setting_notif_push') ?? true;
      _notifEmail = prefs.getBool('setting_notif_email') ?? false;
      _faceId = prefs.getBool('setting_face_id') ?? true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: AppBar(
        title: const Text('Pengaturan', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
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
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
          children: [
            _buildSectionHeader('Notifikasi'),
            const SizedBox(height: 16),
            _buildSettingsContainer([
              _buildSwitchItem('Push Notification', 'Dapatkan update langsung', _notifPush, (v) {
                setState(() => _notifPush = v);
                _saveSetting('setting_notif_push', v);
              }),
              _buildSwitchItem('Email Notification', 'Dapatkan info promo & berita', _notifEmail, (v) {
                setState(() => _notifEmail = v);
                _saveSetting('setting_notif_email', v);
              }),
            ]),
            const SizedBox(height: 24),
            _buildSectionHeader('Keamanan'),
            const SizedBox(height: 16),
            _buildSettingsContainer([
              _buildSwitchItem('Face ID / Biometrik', 'Login lebih cepat', _faceId, (v) {
                setState(() => _faceId = v);
                _saveSetting('setting_face_id', v);
              }),
              _buildActionItem('Ubah Password', Icons.lock_outline),
              _buildActionItem('Ubah PIN Transaksi', Icons.pin_outlined),
            ]),
            const SizedBox(height: 24),
            _buildSectionHeader('Preferensi'),
            const SizedBox(height: 16),
            _buildSettingsContainer([
              _buildActionItem('Bahasa', Icons.language, trailingText: 'Indonesia'),
              _buildActionItem('Tema', Icons.brightness_4_outlined, trailingText: 'Sistem'),
            ]),
          ],
        ),
       ),
      ),
     ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textGrey),
    );
  }

  Widget _buildSettingsContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: children.asMap().entries.map((entry) {
              final idx = entry.key;
              final child = entry.value;
              if (idx < children.length - 1) {
                return Column(
                  children: [
                    child,
                    const Divider(height: 1, indent: 16, endIndent: 16),
                  ],
                );
              }
              return child;
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchItem(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(String title, IconData icon, {String? trailingText}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).hideCurrentSnackBar(); ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fitur "$title" belum tersedia di versi ini.', style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.black87,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              ),
              if (trailingText != null) ...[
                Text(trailingText, style: const TextStyle(fontSize: 14, color: AppColors.textGrey)),
                const SizedBox(width: 8),
              ],
              const Icon(Icons.chevron_right, color: AppColors.iconGrey),
            ],
          ),
        ),
      ),
    );
  }
}
