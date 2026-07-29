import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_catalogue/app/routes.dart';
import 'package:product_catalogue/models/product_model.dart';
import 'package:product_catalogue/providers/favourite_provider.dart';
import 'package:product_catalogue/providers/product_provider.dart';
import 'package:product_catalogue/providers/theme_provider.dart';
import 'package:product_catalogue/services/database/favourite_database_service.dart';
import 'package:product_catalogue/services/database/theme_database_service.dart';
import 'package:product_catalogue/services/network/product_service.dart';
import 'package:product_catalogue/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ProductModelAdapter());

  final favoritesBox = await Hive.openBox<ProductModel>('favorites');
  final settingsBox = await Hive.openBox('settings');

  runApp(
    MultiProvider(
      providers: [
        // product service provider
        Provider(create: (_) => ProductService()),

        // favorite service provider
        Provider(create: (_) => FavouriteDatabaseService(favoritesBox)),

        // theme service provider
        Provider(create: (_) => ThemeDatabaseService(settingsBox)),

        // theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider(context.read<ThemeDatabaseService>())),

        // product provider
        ChangeNotifierProvider(
          create: (context) =>
              ProductProvider(productService: context.read<ProductService>()),
        ),

        // favorite provider
        ChangeNotifierProvider(
          create: (context) => FavouriteProvider(
             context.read<FavouriteDatabaseService>(),
          )..init(),
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
          title: 'Product Catalogue',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.themeMode,
          routerConfig: router,
        );
      },
    );
  }
}
