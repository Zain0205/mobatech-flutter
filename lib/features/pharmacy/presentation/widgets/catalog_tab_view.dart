import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../providers/pharmacy_provider.dart';
import '../widgets/shimmer_loading.dart';
import '../../models/medicine.dart';

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
                    _buildCategoryChip(null, AppStrings.allCategory),
                    ...categories.map((c) => _buildCategoryChip(c.id, c.name)),
                  ],
                ),
              ),
              loading: () => Row(
                children: List.generate(
                  4,
                  (index) => const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: ShimmerLoading(width: 80, height: 35, borderRadius: 20),
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
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildMedicineCard(medicines[index], context);
                },
                childCount: medicines.length,
              ),
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
                (context, index) => const ShimmerLoading(width: double.infinity, height: double.infinity, borderRadius: 16),
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

  Widget _buildCategoryChip(int? id, String label) {
    final isSelected = _selectedCategoryId == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() => _selectedCategoryId = id);
          }
        },
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.textWhite : AppColors.textDark,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.borderGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineCard(Medicine medicine, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.backgroundWave,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Icon(Icons.medication, size: 48, color: AppColors.backgroundWhite),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        medicine.genericName,
                        style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${medicine.price.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14),
                      ),
                      medicine.requiresPrescription
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(AppStrings.prescriptionLabel, style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                            )
                          : GestureDetector(
                              onTap: () {
                                ref.read(cartProvider.notifier).addToCart(medicine.id, 1);
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${medicine.name}${AppStrings.addedToCartSuffix}'),
                                    backgroundColor: AppColors.successGreen,
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.add, color: AppColors.primary, size: 16),
                              ),
                            )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
