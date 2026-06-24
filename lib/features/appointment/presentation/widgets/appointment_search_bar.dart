part of 'appointment_header_widgets.dart';

class AppointmentSearchBar extends ConsumerWidget {
  final TextEditingController searchController;

  const AppointmentSearchBar({super.key, required this.searchController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: _buildSearchInput(ref)),
          const SizedBox(width: 12),
          _buildFilterButton(context),
        ],
      ),
    );
  }

  Widget _buildSearchInput(WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) =>
                ref.read(searchQueryProvider.notifier).state = value,
            style: const TextStyle(color: AppColors.backgroundWhite),
            decoration: const InputDecoration(
              hintText: 'Cari dokter atau spesialis...',
              hintStyle: TextStyle(color: AppColors.textWhite70, fontSize: 13),
              prefixIcon: Icon(Icons.search, color: AppColors.backgroundWhite, size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppointmentSortBottomSheet.show(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.tune, color: AppColors.backgroundWhite, size: 20),
          ),
        ),
      ),
    );
  }
}
