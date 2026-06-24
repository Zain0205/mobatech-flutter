part of 'medical_records_screen.dart';

class _MedicalRecordsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _MedicalRecordsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        AppStrings.extDatarekammedis,
        style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold),
      ),
      backgroundColor: AppColors.primary,
      centerTitle: true,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.backgroundWhite),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppointmentsList extends StatelessWidget {
  final AsyncValue<List<dynamic>> appointmentsAsync;

  const _AppointmentsList({required this.appointmentsAsync});

  @override
  Widget build(BuildContext context) {
    return appointmentsAsync.when(
      data: (appointments) {
        if (appointments.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(AppStrings.extBelumadariwayatmedis, style: TextStyle(color: AppColors.textGrey)),
              ),
            ),
          );
        }
        final sorted = List.of(appointments)
          ..sort((a, b) {
            final dateA = a.schedule?.date ?? DateTime.now();
            final dateB = b.schedule?.date ?? DateTime.now();
            return dateB.compareTo(dateA);
          });

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final appt = sorted[index];
              final isDone = appt.status.toLowerCase() == 'completed';
              final dateStr = appt.schedule?.date != null
                  ? DateFormat('dd MMM yyyy').format(appt.schedule!.date ?? DateTime.now())
                  : '-';
              final docSpec = appt.doctor?.specialization ?? 'Umum';
              final docName = appt.doctor?.name ?? 'Dokter Tidak Diketahui';

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MedicalRecordCard(
                  date: dateStr,
                  type: 'Konsultasi $docSpec',
                  doctor: docName,
                  status: appt.status.toUpperCase(),
                  icon: Icons.medical_services_outlined,
                  color: isDone ? AppColors.primary : AppColors.iconOrange,
                ),
              );
            }, childCount: sorted.length),
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SkeletonLoader(width: double.infinity, height: 100, borderRadius: 20),
              SizedBox(height: 16),
              SkeletonLoader(width: double.infinity, height: 100, borderRadius: 20),
            ],
          ),
        ),
      ),
      error: (err, stack) => SliverToBoxAdapter(
        child: Center(child: Text(ErrorHandler.getMessage(err))),
      ),
    );
  }
}
