import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalogue/theme/app_dimensions.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';

class ExploreProductsButtonWidget extends StatelessWidget {
  final double paddingVertical;
  final double paddingHorizontal;
  const ExploreProductsButtonWidget({
    super.key,
    this.paddingVertical = 18,
    this.paddingHorizontal = 10,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/home'),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          boxShadow: [
            BoxShadow(
              color: context.theme.colorScheme.secondary.withOpacity(0.3),
              blurRadius: AppDimensions.buttonRadius,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/svg/home.svg',
              width: 18,
              height: 18,
              color: context.theme.colorScheme.onTertiary,
            ),
            const SizedBox(width: 10),
            Text(
              'Explore Products',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
