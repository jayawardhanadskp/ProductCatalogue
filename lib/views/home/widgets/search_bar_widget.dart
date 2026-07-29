import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_catalogue/providers/product_provider.dart';
import 'package:product_catalogue/theme/app_colors.dart';
import 'package:product_catalogue/theme/app_dimensions.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';
import 'package:provider/provider.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  late final ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();
    _productProvider = context.read<ProductProvider>();
    _productProvider.addListener(_syncControllerWithProvider);
  }

  void _syncControllerWithProvider() {
    if (_searchController.text != _productProvider.currentQuery) {
      _searchController.text = _productProvider.currentQuery;
    }
  }

  @override
  void dispose() {
    _productProvider.removeListener(_syncControllerWithProvider);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          const Icon(CupertinoIcons.search),
          Expanded(
            child: TextField(
              controller: _searchController,
              cursorColor: AppColors.secondary,
              decoration: InputDecoration(
                hintText: 'Search',
                fillColor: context.theme.colorScheme.primaryContainer,
                hintStyle: context.textTheme.bodyMedium?.copyWith(
                  color: context.theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w300,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                suffix: Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                    if (productProvider.isSearchLoading) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.theme.colorScheme.secondary,
                          ),
                        ),
                      );
                    }

                    if (_searchController.text.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 2, right: 15),
                        child: GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            context.read<ProductProvider>().searchProducts('');
                          },
                          child: Icon(
                            Icons.clear,
                            size: 18,
                            color: context.theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              onChanged: (value) {
                context.read<ProductProvider>().searchProducts(value);
              },

              onTapOutside: (_) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ],
      ),
    );
  }
}
