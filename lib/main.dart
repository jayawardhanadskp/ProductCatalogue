import 'package:flutter/material.dart';
import 'package:product_catalogue/app/app_shell.dart';
import 'package:product_catalogue/app/routes.dart';
import 'package:product_catalogue/providers/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const MyApp(),
  ));
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
      }
    );
  }
}