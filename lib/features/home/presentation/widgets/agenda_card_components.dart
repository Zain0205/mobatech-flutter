part of 'agenda_card.dart';

class _DoctorInfo extends StatelessWidget {
  final Appointment appointment;
  const _DoctorInfo({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDoctorName(),
                const SizedBox(height: 8),
                _buildDoctorSpecialization(),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _DoctorImage(appointment: appointment),
        ],
      ),
    );
  }

  Widget _buildDoctorName() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.agendaHeader,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        appointment.doctor?.name ?? 'Nama Dokter',
        style: const TextStyle(
          color: AppColors.textWhite,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDoctorSpecialization() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGrey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        appointment.doctor?.specialization ?? 'Spesialis',
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _DoctorImage extends StatelessWidget {
  final Appointment appointment;
  const _DoctorImage({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: appointment.doctor?.imageUrl != null &&
              !appointment.doctor!.imageUrl.contains('.svg')
          ? Image.network(
              appointment.doctor!.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) => _fallbackImage(),
            )
          : _fallbackImage(),
    );
  }

  Widget _fallbackImage() {
    return Image.asset(
      'assets/doctor.png',
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    );
  }
}

class _ScheduleInfo extends StatelessWidget {
  final Appointment appointment;
  const _ScheduleInfo({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.agendaBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getScheduleText(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Status: ${appointment.status}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  String _getScheduleText() {
    if (appointment.schedule != null && appointment.schedule!.date != null) {
      final date = appointment.schedule!.date!;
      return '${_getDayOfWeek(date)}, ${_formatDate(date)} . ${appointment.schedule!.startTime}';
    }
    return 'Jadwal belum ditentukan';
  }

  String _getDayOfWeek(DateTime date) {
    final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return days[date.weekday - 1];
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
