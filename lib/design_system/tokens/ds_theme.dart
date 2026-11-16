import 'package:flutter/material.dart';

import 'ds_colors.dart';

abstract final class DSTheme {
  static final dark = _build(Brightness.dark, DSPalette.dark);
  static final light = _build(Brightness.light, DSPalette.light);

  static ThemeData _build(Brightness brightness, DSPalette palette) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: palette.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: DSColors.highlight,
        brightness: brightness,
        primary: DSColors.highlight,
        onPrimary: DSColors.onHighlight,
        surface: palette.background,
        error: DSColors.warning,
      ),
      iconTheme: IconThemeData(color: palette.textPrimary),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      drawerTheme: DrawerThemeData(backgroundColor: palette.background),
      extensions: [palette],
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: palette.textPrimary,
        displayColor: palette.textPrimary,
      ),
    );
  }
}
