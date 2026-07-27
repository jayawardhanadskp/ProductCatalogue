import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:product_catalogue/providers/product_provider.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';
import 'package:product_catalogue/views/home/widgets/category_widget.dart';
import 'package:product_catalogue/views/home/widgets/product_card.dart';
import 'package:product_catalogue/views/home/widgets/search_bar_widget.dart';
import 'package:product_catalogue/widgets/toggle_theme_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProductProvider _productProvider;
  late final ScrollController _scrollController;
  late final ScrollController _categoryScrollController;

  String _previousCategory = 'All Items';

  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _productProvider.loadInitialProducts();
      _productProvider.loadCategoryList();
    });
    _scrollController = ScrollController();
    _categoryScrollController = ScrollController();

    _scrollController.addListener(_onScroll);
    _productProvider.addListener(_syncCategoryScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    const threshold = 300.0;
    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - threshold &&
        !_productProvider.isPaginatingLoading &&
        !_productProvider.isInitialLoading &&
        _productProvider.hasMore) {
      _productProvider.loadMore();
    }
  }

  void _syncCategoryScroll() {
    final current = _productProvider.selectedCategory;
    if (current == 'All Items' &&
        current != _previousCategory &&
        _categoryScrollController.hasClients) {
      _categoryScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
    _previousCategory = current;
  }

  @override
  void dispose() {
    _productProvider.removeListener(_syncCategoryScroll);
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _categoryScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: context.theme.scaffoldBackgroundColor,
              surfaceTintColor: context.theme.scaffoldBackgroundColor,
              toolbarHeight: 56,

              title: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Discover', style: context.textTheme.headlineSmall),
                      Text(
                        'Find products you\'ll love',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8,)
                    ],
                  ),
                  ThemeToggleButton(),
                ],
              ),

              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(120),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 4.0,
                  ),
                  child: Column(
                    children: [
                      const SearchBarWidget(),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40,
                        child: Consumer<ProductProvider>(
                          builder: (context, productProvider, _) {
                            if (productProvider.categoryError != null) {
                              return Text(
                                productProvider.categoryError.toString(),
                              );
                            }
                            return ListView.builder(
                              controller: _categoryScrollController,
                              itemCount: productProvider.categories.length,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              dragStartBehavior: DragStartBehavior.values.first,
                              itemBuilder: (context, index) {
                                final String categoryName =
                                    productProvider.categories[index];
                                final bool isSelected =
                                    productProvider.selectedCategory ==
                                    categoryName;

                                return CategoryWidget(
                                  onTap: () {
                                    productProvider.loadProductsByCategory(
                                      categoryName,
                                    );
                                  },
                                  categoryName: categoryName,
                                  isSelected: isSelected,
                                  index: index,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 80),
              sliver: Consumer<ProductProvider>(
                builder: (context, productProvider, _) {
                  if (productProvider.isInitialLoading ||
                      productProvider.isSearchLoading ||
                      productProvider.isCategoryProductsLoading) {
                    return SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }
                  if (productProvider.initialError != null) {
                    return SliverFillRemaining(
                      child: Center(child: Text(productProvider.initialError!)),
                    );
                  }
                  if (productProvider.products.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text("No products")),
                    );
                  }
                  return SliverGrid.builder(
                    itemCount: productProvider.products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.66,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(
                        productModel: productProvider.products[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
