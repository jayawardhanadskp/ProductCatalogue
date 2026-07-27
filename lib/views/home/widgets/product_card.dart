// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalogue/models/product_model.dart';
import 'package:product_catalogue/providers/favourite_provider.dart';
import 'package:product_catalogue/theme/app_colors.dart';
import 'package:product_catalogue/theme/app_dimensions.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';
import 'package:product_catalogue/widgets/app_network_image_widget.dart';
import 'package:product_catalogue/widgets/app_snack_bars.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final ProductModel productModel;
  const ProductCard({super.key, required this.productModel});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        GoRouter.of(context).push('/details', extra: widget.productModel);
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppDimensions.radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: AppNetworkImageWidget(
                    imageUrl:
                        widget.productModel.images.first ??
                        'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_t.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Selector<FavouriteProvider, bool>(
                    selector: (context, favProvider) =>
                        favProvider.isFavourite(widget.productModel.id),
                    builder: (context, isFavorite, _) {
                      return GestureDetector(
                        
                        onTap: () async {

                          final String message = isFavorite 
                              ? 'Removed from favorites' 
                              : 'Added to favorites';

                          final bool isSuccess = await Provider.of<FavouriteProvider>(
                            context,
                            listen: false,
                          ).toggleFavorite(widget.productModel);

                          if (!mounted) return;

                          if (isSuccess) {
                            context.showSuccessSnackbar(message);
                          } else {
                            context.showErrorSnackbar('Failed to update favorite.');
                          }
                        },
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.surface
                                .withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            size: 18,
                            color: isFavorite
                                ? AppColors.favorite
                                : context.theme.colorScheme.tertiary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productModel.title,
                    style: context.textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    widget.productModel.description,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w200,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.productModel.price.toStringAsFixed(2),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.theme.colorScheme.secondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
