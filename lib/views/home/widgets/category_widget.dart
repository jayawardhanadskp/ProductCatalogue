import 'package:flutter/material.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';

class CategoryWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String categoryName;
  final bool isSelected;
  final int index;
  const CategoryWidget({super.key,
    required this.onTap,
    required this.categoryName,
    required this.isSelected,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: index == 0
              ? EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.3)
              : EdgeInsets.zero,
          child: Text(
            categoryName.substring(0, 1).toUpperCase() +
                categoryName.substring(1),
            style: context.textTheme.displayLarge?.copyWith(
              color: isSelected
                  ? context.theme.colorScheme.tertiary
                  : context.theme.colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
