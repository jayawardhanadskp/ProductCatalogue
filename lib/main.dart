import 'package:flutter/material.dart';
import 'package:product_catalogue/app/routes.dart';
import 'package:product_catalogue/providers/product_provider.dart';
import 'package:product_catalogue/providers/theme_provider.dart';
import 'package:product_catalogue/services/network/product_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // product service provider
        Provider(create: (_) => ProductService()),

        ChangeNotifierProvider(create: (context) => ThemeProvider()),

        // product provider
        ChangeNotifierProxyProvider<ProductService, ProductProvider>(
          create: (context) => ProductProvider(),
          update: (context, productService, previousProductProvider) {
            return previousProductProvider ??
                ProductProvider(productService: productService);
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'Proudct Catalogue',
          theme: themeProvider.theme,
          // home: AppShell()
          routerConfig: router,
        );
      },
    );
  }
}
