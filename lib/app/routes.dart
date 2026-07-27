import 'package:go_router/go_router.dart';
import 'package:product_catalogue/app/app_shell.dart';
import 'package:product_catalogue/models/product_model.dart';
import 'package:product_catalogue/views/cart/cart_screen.dart';
import 'package:product_catalogue/views/favorites_screen.dart';
import 'package:product_catalogue/views/home/home_screen.dart';
import 'package:product_catalogue/views/product/product_details_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    // --- INSIDE THE NAVIGATION BAR SHELL ---
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favourite',
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/details',
      builder: (context, state) {
        final productModel = state.extra as ProductModel;
        return ProductDetailsScreen(productModel: productModel);
      },
    ),
  ],
);
