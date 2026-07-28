import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_catalogue/providers/theme_provider.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';
import 'package:provider/provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return PopupMenuButton<ThemeMode>(
      icon: Icon(_iconFor(themeProvider.themeMode, context), color: context.theme.colorScheme.tertiary,),
      onSelected: (mode) => context.read<ThemeProvider>().setThemeMode(mode),
      itemBuilder: (context) => [
        const PopupMenuItem(value: ThemeMode.system, child: Text('System default')),
        const PopupMenuItem(value: ThemeMode.light, child: Text('Light')),
        const PopupMenuItem(value: ThemeMode.dark, child: Text('Dark')),
      ],
    );
  }

  IconData _iconFor(ThemeMode mode, BuildContext context) {
    switch (mode) {
      case ThemeMode.light:
        return CupertinoIcons.sun_max;
      case ThemeMode.dark:
        return CupertinoIcons.moon;
      case ThemeMode.system:
        return CupertinoIcons.gear;
    }
  }
}