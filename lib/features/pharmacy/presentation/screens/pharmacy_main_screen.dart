import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../providers/pharmacy_provider.dart';
import '../widgets/catalog_tab_view.dart';
import '../widgets/prescription_tab_view.dart';
import '../widgets/orders_tab_view.dart';

part 'pharmacy_app_bar.dart';

class PharmacyMainScreen extends ConsumerStatefulWidget {
  const PharmacyMainScreen({super.key});

  @override
  ConsumerState<PharmacyMainScreen> createState() => _PharmacyMainScreenState();
}

class _PharmacyMainScreenState extends ConsumerState<PharmacyMainScreen>
    with SingleTickerProviderStateMixin {
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
      data: (cart) =>
          cart.items.fold<int>(0, (sum, item) => sum + item.quantity),
      loading: () => 0,
      error: (_, __) => 0,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _PharmacyAppBar(
              cartItemCount: cartItemCount,
              tabController: _tabController,
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
