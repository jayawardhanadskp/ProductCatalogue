// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalogue/theme/app_colors.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';
import 'package:product_catalogue/views/cart/cart_screen.dart';
import 'package:product_catalogue/views/favourite_screen.dart';
import 'package:product_catalogue/views/home/home_screen.dart';

class AppShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const AppShell({
    required this.navigationShell,
    super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
            body: widget.navigationShell,

      bottomNavigationBar: Container(
        height: 110,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // main layer
            Container(
              height: 75,
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () => widget.navigationShell.goBranch(0, initialLocation: true),
                    child: Container(
                      width: 50,
                      padding: EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/svg/home.svg',
                        color: widget.navigationShell.currentIndex == 0
                            ? AppColors.secondary
                            : AppColors.lightIcon,
                      ),
                    ),
                  ),

                  const SizedBox(width: 60),

                  InkWell(
                    onTap: () => widget.navigationShell.goBranch(2, initialLocation: true),
                    child: Container(
                      width: 50,
                      padding: EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/svg/bag.svg',
                        color: widget.navigationShell.currentIndex == 2
                            ? AppColors.secondary
                            : AppColors.lightIcon,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // fav
            Positioned(
              top: 0,
              child: InkWell(
                onTap: () {
                  widget.navigationShell.goBranch(1, initialLocation: true);
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.tertiary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.darkBackground.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    CupertinoIcons.heart,
                    color: widget.navigationShell.currentIndex == 1
                        ? AppColors.secondary
                        : context.theme.colorScheme.onTertiary,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
