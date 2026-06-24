import 'package:flutter/material.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../providers/pharmacy_provider.dart';
import '../widgets/shimmer_loading.dart';
import 'catalog_widgets.dart';

class CatalogTabView extends ConsumerStatefulWidget {
  const CatalogTabView({super.key});

  @override
  ConsumerState<CatalogTabView> createState() => _CatalogTabViewState();
}

class _CatalogTabViewState extends ConsumerState<CatalogTabView> {
  int? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final medicinesAsync = ref.watch(medicinesProvider(_selectedCategoryId));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: categoriesAsync.when(
              data: (categories) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryChip(
                      label: AppStrings.allCategory,
                      isSelected: _selectedCategoryId == null,
                      onSelected: () =>
                          setState(() => _selectedCategoryId = null),
                    ),
                    ...categories.map(
                      (c) => CategoryChip(
                        label: c.name,
                        isSelected: _selectedCategoryId == c.id,
                        onSelected: () =>
                            setState(() => _selectedCategoryId = c.id),
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => Row(
                children: List.generate(
                  4,
                  (index) => const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: ShimmerLoading(
                      width: 80,
                      height: 35,
                      borderRadius: 20,
                    ),
                  ),
                ),
              ),
              error: (err, stack) => const Text(AppStrings.errorLoadCategories),
            ),
          ),
        ),
        medicinesAsync.when(
          data: (medicines) => SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return MedicineCard(
                  medicine: medicines[index],
                  onAddToCart: () {
                    ref
                        .read(cartProvider.notifier)
                        .addToCart(medicines[index].id, 1);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    CustomSnackbar.showSuccess(context, '${medicines[index].name}${AppStrings.addedToCartSuffix}',);
                  },
                );
              }, childCount: medicines.length),
            ),
          ),
          loading: () => SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => const ShimmerLoading(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: 16,
                ),
                childCount: 4,
              ),
            ),
          ),
          error: (err, stack) => const SliverToBoxAdapter(
            child: Center(child: Text(AppStrings.errorLoadMedicines)),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}
