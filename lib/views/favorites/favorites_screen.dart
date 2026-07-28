// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalogue/providers/favourite_provider.dart';
import 'package:product_catalogue/theme/app_dimensions.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';
import 'package:product_catalogue/views/home/widgets/product_card.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              centerTitle: true,
              toolbarHeight: 70,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      const SizedBox(),
                      const SizedBox(),
                      Text(
                        'My Favorites',
                        style: context.textTheme.displayLarge,
                      ),

                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: context.theme.cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Consumer<FavouriteProvider>(
                            builder: (context, favProvider, _) {
                              final int count = favProvider.favourites.length;
                              if (favProvider.favourites.isNotEmpty) {
                                return Text(
                                  count.toString(),
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              pinned: true,
              backgroundColor: context.theme.appBarTheme.backgroundColor,
              surfaceTintColor: context.theme.appBarTheme.foregroundColor,
            ),

            Consumer<FavouriteProvider>(
              builder: (context, favoritesProvider, _) {
                final favorites = favoritesProvider.favourites;

                if (favorites.isEmpty) {
                  return _EmptyFavorites();
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: Platform.isAndroid ? 0.73 : 0.7,
                    ),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final product = favorites[index];
                      return ProductCard(
                        key: ValueKey('fav_${product.id}'),
                        productModel: product,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.heart,
              size: 64,
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 0),
            Text('No favourites yet', style: context.textTheme.bodyLarge),
            const SizedBox(height: 18),
            const _ExploreProductsButton(),
          ],
        ),
      ),
    );
  }
}

class _ExploreProductsButton extends StatelessWidget {
  const _ExploreProductsButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/home'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
