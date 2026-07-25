import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:product_catalogue/providers/product_provider.dart';
import 'package:product_catalogue/providers/theme_provider.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';
import 'package:product_catalogue/views/home/widgets/category_widget.dart';
import 'package:product_catalogue/views/home/widgets/product_card.dart';
import 'package:product_catalogue/views/home/widgets/search_bar_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProductProvider _productProvider;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _productProvider.loadInitialProducts();
      _productProvider.loadCategoryList();
    });
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    const threshold = 100.0;
    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - threshold &&
        !_productProvider.isPaginatingLoading &&
        !_productProvider.isInitialLoading &&
        _productProvider.hasMore) {
      _productProvider.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 55.0, 10.0, 10.0),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: context.theme.scaffoldBackgroundColor,
              surfaceTintColor: context.theme.scaffoldBackgroundColor,
              expandedHeight: 20,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 10, bottom: 10),
                title: Row(
                  mainAxisAlignment: .center,
                  children: [
                    IconButton(
                      onPressed: () =>
                          context.read<ThemeProvider>().toggleTheme(),
                      icon: Icon(Icons.circle),
                    ),

                    Expanded(
                      child: Consumer<ProductProvider>(
                        builder: (context, productProvider, _) {
                          if (productProvider.categoryError != null) {
                            return Text(
                              productProvider.categoryError.toString(),
                            );
                          }
                          return ListView.builder(
                            itemCount: productProvider.categories.length,
                            shrinkWrap: true,
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
                                  productProvider
                                      .loadProductsByCategory(categoryName);
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(15),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: SearchBarWidget(),
                ),
              ),
            ),

            // SliverPadding(
            //   padding: EdgeInsets.only(top: AppDimensions.top),
            //   sliver: SliverToBoxAdapter(
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Icon(Icons.list_rounded),
            //         Text('All Items', style: context.textTheme.displayLarge),
            //         IconButton(
            //           onPressed: () =>
            //               context.read<ThemeProvider>().toggleTheme(),
            //           icon: Icon(Icons.circle),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 20.0),
            //     child: const SearchBarWidget(),
            //   ),
            // ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 80),
              sliver: Consumer<ProductProvider>(
                builder: (context, productProvider, _) {
                  if (productProvider.isInitialLoading) {
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
