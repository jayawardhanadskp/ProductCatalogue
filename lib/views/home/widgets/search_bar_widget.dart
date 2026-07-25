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
          Icon(CupertinoIcons.search),
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
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                suffix: Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                    if (productProvider.isSearchLoading) {
                      return Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.theme.colorScheme.secondary,
                          ),
                        ),
                      );
                    }

                    if (_searchController.text.isNotEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(top: 2, right: 15),
                        child: SizedBox(
                          width: 12,
                          height: 20,
                          child: GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              context.read<ProductProvider>().searchProducts(
                                '',
                              );
                            },
                            child: Icon(
                              Icons.clear,
                              size: 18,
                              color: context.theme.colorScheme.onSurfaceVariant,
                            ),
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
            ),
          ),
        ],
      ),
    );
  }
}
