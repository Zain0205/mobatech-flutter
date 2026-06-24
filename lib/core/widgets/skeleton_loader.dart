import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 16,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: AppColors.borderGrey.withValues(alpha: 0.5),
        highlightColor: AppColors.backgroundWhite,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

class CardSkeletonLoader extends StatelessWidget {
  final int count;

  const CardSkeletonLoader({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: count,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SkeletonLoader(
          width: double.infinity,
          height: 120,
          margin: const EdgeInsets.only(bottom: 16),
          borderRadius: 20,
        );
      },
    );
  }
}

class GridSkeletonLoader extends StatelessWidget {
  final int count;

  const GridSkeletonLoader({super.key, this.count = 8});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: count,
        itemBuilder: (context, index) {
          return const Column(
            children: [
              SkeletonLoader(width: 50, height: 50, borderRadius: 25),
              SizedBox(height: 8),
              SkeletonLoader(width: 60, height: 10, borderRadius: 5),
              SizedBox(height: 4),
              SkeletonLoader(width: 40, height: 10, borderRadius: 5),
            ],
          );
        },
      ),
    );
  }
}
