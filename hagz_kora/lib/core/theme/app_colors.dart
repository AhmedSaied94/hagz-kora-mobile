import 'package:flutter/material.dart';

/// Design token colours for "The Pitch Curator" design system.
///
/// All widgets must reference these constants — never hardcode hex values.
abstract final class AppColors {
  // Primary brand — dark pitch green
  static const primary = Color(0xFF012D1D);
  static const primaryVariant = Color(0xFF014D32);
  static const onPrimary = Color(0xFFFFFFFF);

  // Gold accent
  static const accent = Color(0xFF735C00);
  static const accentLight = Color(0xFFF0C430);
  static const onAccent = Color(0xFF000000);

  // Surfaces
  static const surface = Color(0xFFF8F9FA);
  static const surfaceVariant = Color(0xFFECEFF1);
  static const surfaceTonal = Color(0xFFE0E8E4);
  static const onSurface = Color(0xFF1A1C1E);
  static const onSurfaceVariant = Color(0xFF43474E);

  // Backgrounds
  static const background = Color(0xFFF8F9FA);
  static const onBackground = Color(0xFF1A1C1E);

  // Status
  static const success = Color(0xFF1B7A3E);
  static const warning = Color(0xFFB45309);
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);

  // Text
  static const textPrimary = Color(0xFF1A1C1E);
  static const textSecondary = Color(0xFF43474E);
  static const textDisabled = Color(0xFF8D9199);
  static const textOnDark = Color(0xFFFFFFFF);

  // Bottom nav (dark green bar)
  static const navBar = Color(0xFF012D1D);
  static const navBarItem = Color(0xFF7CBDA0);
  static const navBarItemSelected = Color(0xFFFFFFFF);

  // Dividers and borders
  static const divider = Color(0xFFE0E3E8);
  static const border = Color(0xFFCACDD3);

  // Star rating
  static const starFilled = Color(0xFFF0C430);
  static const starEmpty = Color(0xFFCACACA);
}
