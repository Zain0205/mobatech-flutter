part of 'appointment_header_widgets.dart';

class AppointmentFilterChips extends ConsumerWidget {
  final String selectedSpecialization;

  const AppointmentFilterChips({
    super.key,
    required this.selectedSpecialization,
  });

  Widget _buildFilterChip(
    WidgetRef ref,
    String selected,
    String label,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedSpecializationProvider.notifier).state = label;
      },
      child: AppointmentFilterChip(
        label: label,
        isSelected: selected == label,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      child: Row(
        children: _buildChips(ref),
      ),
    );
  }

  List<Widget> _buildChips(WidgetRef ref) {
    return [
      _buildFilterChip(ref, selectedSpecialization, 'All', Icons.border_all),
      _buildFilterChip(ref, selectedSpecialization, 'Spesialis Anak', Icons.child_care),
      _buildFilterChip(ref, selectedSpecialization, 'Spesialis Gigi', Icons.medical_services_outlined),
      _buildFilterChip(ref, selectedSpecialization, 'Spesialis Penyakit Dalam', Icons.monitor_heart_outlined),
      _buildFilterChip(ref, selectedSpecialization, 'Spesialis Kulit & Kelamin', Icons.face),
      _buildFilterChip(ref, selectedSpecialization, 'Spesialis Kandungan', Icons.pregnant_woman),
    ];
  }
}
