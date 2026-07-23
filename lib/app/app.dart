import 'package:flutter/material.dart';
import 'package:product_catalogue/providers/theme_provider.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(title:  Text('Product Catalogue', style: context.textTheme.displayLarge)),
      body: Column(
        children: [
          const Center(child: Text('Hell')),

          ElevatedButton(
            onPressed: context.read<ThemeProvider>().toggleTheme,
            child: Text('mode'),
          ),
        ],
      ),
    );
  }
}
