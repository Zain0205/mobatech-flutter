part of 'profile_screen.dart';

class ProfileSliverAppBar extends StatelessWidget {
  const ProfileSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(32))),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          AppStrings.extProfilsaya,
          style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        background: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset('assets/header_logo.png', width: 220),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.transparent, AppColors.primary.withValues(alpha: 0.4)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileNullUserView extends ConsumerWidget {
  const ProfileNullUserView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(AppStrings.extDataprofiltidakditemukansilakanloginulang, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed, foregroundColor: AppColors.backgroundWhite),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              globalAuthToken = null;
              ref.invalidate(userProfileProvider);
              if (context.mounted) context.go('/login');
            },
            child: const Text(AppStrings.extKeluardariakun),
          ),
        ],
      ),
    );
  }
}
