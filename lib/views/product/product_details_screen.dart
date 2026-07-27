// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:product_catalogue/models/product_model.dart';
import 'package:product_catalogue/providers/favourite_provider.dart';
import 'package:product_catalogue/theme/app_colors.dart';
import 'package:product_catalogue/theme/app_dimensions.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';
import 'package:product_catalogue/widgets/app_network_image_widget.dart';
import 'package:product_catalogue/widgets/app_snack_bars.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel _productModel;

  const ProductDetailsScreen({super.key, required this._productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget._productModel;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Hero(
                    tag: product.id,
                    child: SizedBox(
                      height: 380,
                      width: double.infinity,
                      child: AppNetworkImageWidget(
                        imageUrl: product.images[0] ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _CircleIconButton(
                            icon: CupertinoIcons.back,
                            onTap: () => Navigator.pop(context),
                          ),
                          Selector<FavouriteProvider, bool>(
                            selector: (context, favProvider) => favProvider
                                .isFavourite(widget._productModel.id),
                            builder: (context, isFavorite, _) {
                              return _CircleIconButton(
                                icon: isFavorite
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                iconColor: isFavorite
                                    ? AppColors.favorite
                                    : context.theme.colorScheme.onSurface,
                                onTap: () async {
                                  final String message = isFavorite
                                      ? 'Removed from favorites'
                                      : 'Added to favorites';

                                  final bool isSucess = await
                                      Provider.of<FavouriteProvider>(
                                        context, listen: false,
                                      ).toggleFavorite(product);
                                  
                                  if (!mounted) return;

                                  if (isSucess) {
                                    context.showSuccessSnackbar(message);
                                  } else {
                                    context.showErrorSnackbar(
                                      'Failed to update favorite.',
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  decoration: BoxDecoration(
                    color: context.theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radius * 1.6),
                      topRight: Radius.circular(AppDimensions.radius * 1.6),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // category chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            product.category.toUpperCase(),
                            style: context.textTheme.bodySmall?.copyWith(
                              // color: context.theme.colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // title
                        Text(
                          product.title,
                          style: context.textTheme.displayLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // rating row + price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RatingBarIndicator(
                              rating: widget._productModel.rating,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemSize: 18.0,
                              // unratedColor: context.theme.colorScheme.onSurfaceVariant,
                              itemBuilder: (context, _) =>
                                  Icon(Icons.star, color: AppColors.rating),
                            ),

                            const SizedBox(width: 6),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: context.textTheme.bodySmall?.copyWith(
                                color:
                                    context.theme.colorScheme.onSurfaceVariant,
                              ),
                            ),

                            const Spacer(),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: context.theme.colorScheme.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Divider(
                          color: context.theme.colorScheme.outlineVariant,
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'About Product',
                          style: context.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          product.description,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w300,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Text(
                              'Quantity',
                              style: context.textTheme.bodyLarge,
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    context.theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radius,
                                ),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (quantity > 1) {
                                        setState(() => quantity--);
                                      }
                                    },
                                    icon: const Icon(CupertinoIcons.minus),
                                  ),
                                  Text(
                                    '$quantity',
                                    style: context.textTheme.bodyLarge,
                                  ),
                                  IconButton(
                                    onPressed: () => setState(() => quantity++),
                                    icon: const Icon(CupertinoIcons.plus),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 90),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.theme.colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.buttonRadius,
                    ),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Add to Cart · \$${(product.price * quantity).toStringAsFixed(2)}',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.theme.colorScheme.surface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor ?? context.theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
