import '../../../../core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/settings_widgets.dart';

part 'settings_screen_parts.dart';


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
      appBar: const SettingsAppBar(),
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
                SectionHeader(title: 'Notifikasi'),
                const SizedBox(height: 16),
                SettingsContainer(
                  children: [
                    SwitchItem(
                      title: 'Push Notification',
                      subtitle: 'Dapatkan update langsung',
                      value: _notifPush,
                      onChanged: (v) {
                        setState(() => _notifPush = v);
                        _saveSetting('setting_notif_push', v);
                      },
                    ),
                    SwitchItem(
                      title: 'Email Notification',
                      subtitle: 'Dapatkan info promo & berita',
                      value: _notifEmail,
                      onChanged: (v) {
                        setState(() => _notifEmail = v);
                        _saveSetting('setting_notif_email', v);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SectionHeader(title: 'Keamanan'),
                const SizedBox(height: 16),
                SettingsContainer(
                  children: [
                    SwitchItem(
                      title: 'Face ID / Biometrik',
                      subtitle: 'Login lebih cepat',
                      value: _faceId,
                      onChanged: (v) {
                        setState(() => _faceId = v);
                        _saveSetting('setting_face_id', v);
                      },
                    ),
                    const ActionItem(
                      title: 'Ubah Password',
                      icon: Icons.lock_outline,
                    ),
                    const ActionItem(
                      title: 'Ubah PIN Transaksi',
                      icon: Icons.pin_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SectionHeader(title: 'Preferensi'),
                const SizedBox(height: 16),
                const SettingsContainer(
                  children: [
                    ActionItem(
                      title: 'Bahasa',
                      icon: Icons.language,
                      trailingText: 'Indonesia',
                    ),
                    ActionItem(
                      title: 'Tema',
                      icon: Icons.brightness_4_outlined,
                      trailingText: 'Sistem',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
