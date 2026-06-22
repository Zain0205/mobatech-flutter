import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../providers/pharmacy_provider.dart';
import '../widgets/catalog_tab_view.dart';
import '../widgets/prescription_tab_view.dart';
import '../widgets/orders_tab_view.dart';

class PharmacyMainScreen extends ConsumerStatefulWidget {
  const PharmacyMainScreen({super.key});

  @override
  ConsumerState<PharmacyMainScreen> createState() => _PharmacyMainScreenState();
}

class _PharmacyMainScreenState extends ConsumerState<PharmacyMainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartAsync = ref.watch(cartProvider);
    final cartItemCount = cartAsync.when(
      data: (cart) => cart.items.fold<int>(0, (sum, item) => sum + item.quantity),
      loading: () => 0,
      error: (_, __) => 0,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              pinned: true,
              backgroundColor: AppColors.primary,
              iconTheme: const IconThemeData(color: AppColors.textWhite),
              title: const Text(AppStrings.pharmacyTitle, style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
              actions: [
                Stack(
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
                          decoration: const BoxDecoration(color: AppColors.errorRed, shape: BoxShape.circle),
                          child: Text('$cartItemCount', style: const TextStyle(color: AppColors.textWhite, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: 0,
                      child: Opacity(opacity: 0.2, child: Image.asset('assets/header_logo.png', width: 150)),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  ),
                  child: TabBar(
                    controller: _tabController,
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
              ),
            ),
          ];
        },
        body: Container(
          color: AppColors.backgroundWhite,
          child: TabBarView(
            controller: _tabController,
            children: const [
              CatalogTabView(),
              PrescriptionTabView(),
              OrdersTabView(),
            ],
          ),
        ),
      ),
    );
  }
}
