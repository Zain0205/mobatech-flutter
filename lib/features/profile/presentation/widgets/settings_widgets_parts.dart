part of 'settings_widgets.dart';

class SwitchItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const SwitchItem({super.key, required this.title, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
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
          Switch(value: value, onChanged: onChanged, activeThumbColor: AppColors.primary),
        ],
      ),
    );
  }
}

class ActionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? trailingText;

  const ActionItem({super.key, required this.title, required this.icon, this.trailingText});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: _buildRowChildren(),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    CustomSnackbar.showError(context, 'Fitur "$title" belum tersedia di versi ini.');
  }

  List<Widget> _buildRowChildren() {
    return [
      Icon(icon, color: AppColors.primary, size: 24),
      const SizedBox(width: 16),
      Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark))),
      if (trailingText != null) ...[
        Text(trailingText!, style: const TextStyle(fontSize: 14, color: AppColors.textGrey)),
        const SizedBox(width: 8),
      ],
      const Icon(Icons.chevron_right, color: AppColors.iconGrey),
    ];
  }
}
