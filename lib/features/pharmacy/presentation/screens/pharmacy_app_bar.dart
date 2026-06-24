part of 'pharmacy_main_screen.dart';

class _PharmacyAppBar extends StatelessWidget {
  final int cartItemCount;
  final TabController tabController;

  const _PharmacyAppBar({
    required this.cartItemCount,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(color: AppColors.textWhite),
      title: const Text(
        AppStrings.pharmacyTitle,
        style: TextStyle(
          color: AppColors.textWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        _buildCartAction(context),
        const SizedBox(width: 8),
      ],
      flexibleSpace: _buildFlexibleSpace(),
      bottom: _buildTabBar(),
    );
  }

  Widget _buildCartAction(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.textWhite),
          onPressed: () => context.push('/pharmacy/cart'),
        ),
        if (cartItemCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.errorRed,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$cartItemCount',
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFlexibleSpace() {
    return FlexibleSpaceBar(
      background: Stack(
        children: [
          Positioned(
            right: -20,
            top: 0,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset('assets/header_logo.png', width: 150),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: TabBar(
          controller: tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textGrey,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: AppStrings.catalogTab),
            Tab(text: AppStrings.ePrescriptionTab),
            Tab(text: AppStrings.ordersTab),
          ],
        ),
      ),
    );
  }
}
