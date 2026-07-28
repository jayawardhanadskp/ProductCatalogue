import 'package:flutter/material.dart';
import 'package:product_catalogue/theme/app_dimensions.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';
import 'package:shimmer/shimmer.dart';

class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: itemCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.66,
      ),
      itemBuilder: (context, index) => const ProductCardShimmer(),
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = context.theme.colorScheme.primaryContainer;
    final highlightColor = context.theme.colorScheme.surface;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(AppDimensions.radius),
        ),
        
      ),
    );
  }
}