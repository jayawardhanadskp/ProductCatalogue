// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_catalogue/theme/app_dimensions.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';
import 'package:product_catalogue/widgets/explore_products_button_widget.dart';

/// NOTE: Static UI demonstration only — not wired to real cart state.
/// Cart management wasn't part of the assessment's core requirements;
/// this screen exists purely to show the intended layout/flow.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: context.theme.appBarTheme.backgroundColor,
        surfaceTintColor: context.theme.appBarTheme.backgroundColor,
        centerTitle: true,
        title: Text('My Bag', style: context.textTheme.displayLarge),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.tertiary.withOpacity(
                        0.15,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.radius),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.info_circle,
                          size: 16,
                          color: context.theme.colorScheme.tertiary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'UI demonstration only. Not connected to real cart data.',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.theme.colorScheme.tertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(AppDimensions.radius),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.separated(
                      itemCount: 2,
                      separatorBuilder: (_, _) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final color = context.theme.cardTheme.color;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 18,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Container(
                                    height: 14,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),

                                  const SizedBox(height: 18),

                                  Row(
                                    children: [
                                      Container(
                                        width: 90,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),

                                      const Spacer(),

                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              left: 20,
              right: 20,
              bottom: 90,
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.theme.cardTheme.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radius),
                    ),
                  ),
                  onPressed: null,
                  child: Text(
                    'PROCEED TO CHECKOUT',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.theme.colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(child: ExploreProductsButtonWidget(paddingHorizontal: 28, paddingVertical: 15,)),
            ),
          ],
        ),
      ),
    );
  }
}
