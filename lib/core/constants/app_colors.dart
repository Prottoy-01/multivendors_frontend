import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFFFF6584);
  static const Color accent = Color(0xFFFFD166);

  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFFB2BEC3);

  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF74B9FF);

  static const Color border = Color(0xFFDFE6E9);
  static const Color divider = Color(0xFFECF0F1);

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return warning;
      case 'paid':
      case 'processing':
        return info;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return success;
      case 'cancelled':
        return error;
      default:
        return textSecondary;
    }
  }

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
