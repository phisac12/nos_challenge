import 'package:flutter/material.dart';

import 'ds_colors.dart';

abstract final class DSTheme {
  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: DSColors.background,
    colorScheme: const ColorScheme.dark(
      primary: DSColors.highlight,
      onPrimary: DSColors.onHighlight,
      surface: DSColors.surface,
      error: DSColors.warning,
    ),
  );
}
