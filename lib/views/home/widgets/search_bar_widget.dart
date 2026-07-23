import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_catalogue/theme/app_colors.dart';
import 'package:product_catalogue/theme/app_dimensions.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

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
          const SizedBox(width: 15,),
          Icon(CupertinoIcons.search),
          Expanded(
            child: TextField(
              cursorColor: AppColors.secondary,
              decoration: InputDecoration(
                hintText: 'Search',
                fillColor: context.theme.colorScheme.primaryContainer,
                hintStyle: context.textTheme.bodyMedium?.copyWith(
                  color: context.theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w300
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          )
        ],
      ),
    );
  }
}