import 'package:flutter/material.dart';
import 'package:product_catalogue/theme/app_colors.dart';
import 'package:product_catalogue/theme/app_dimensions.dart';
import 'package:product_catalogue/theme/theme_extensions.dart';

extension ScaffoldMessengerX on BuildContext {

   void showSuccessSnackbar(String message) {
    _show(message, AppColors.success,  Icons.check_circle_outline);
  }

  void showErrorSnackbar(String message) {
    _show(message, AppColors.error, Icons.error_outline);
  }

  void showWarningSnackbar(String message) {
    _show(message, AppColors.warning, Icons.warning_amber_outlined);
  }

  void showInfoSnackbar(String message) {
    _show(message, theme.colorScheme.tertiary, Icons.info_outline);
  }


  void _show(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiousSm)),
        content: Row(
          children: [
            Icon(icon, color: theme.scaffoldBackgroundColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: theme.scaffoldBackgroundColor, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }


 
}
