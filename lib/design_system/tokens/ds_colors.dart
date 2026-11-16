import 'package:flutter/material.dart';

/// Cores de marca: iguais em light e dark.
abstract final class DSColors {
  static const highlight = Color(0xFFF5C518); // filmes bem classificados
  static const onHighlight = Color(0xFF14130F);
  static const warning = Color(0xFFE5484D); // classificação baixa
}

/// Cores que mudam com o tema. Registada no ThemeData como extensão e lida
/// com `context.palette`.
@immutable
class DSPalette extends ThemeExtension<DSPalette> {
  const DSPalette({
    required this.background,
    required this.surface,
    required this.surfaceHigh,
    required this.textPrimary,
    required this.textSecondary,
  });

  static const dark = DSPalette(
    background: Color(0xFF0E0F13),
    surface: Color(0xFF1A1C23),
    surfaceHigh: Color(0xFF262933),
    textPrimary: Color(0xFFF2F3F5),
    textSecondary: Color(0xFF9AA0AC),
  );

  static const light = DSPalette(
    background: Color(0xFFF7F7F9),
    surface: Color(0xFFE9EAEE),
    surfaceHigh: Color(0xFFDDDFE5),
    textPrimary: Color(0xFF14151A),
    textSecondary: Color(0xFF5E6470),
  );

  final Color background;
  final Color surface;
  final Color surfaceHigh;
  final Color textPrimary;
  final Color textSecondary;

  @override
  DSPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceHigh,
    Color? textPrimary,
    Color? textSecondary,
  }) => DSPalette(
    background: background ?? this.background,
    surface: surface ?? this.surface,
    surfaceHigh: surfaceHigh ?? this.surfaceHigh,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
  );

  @override
  DSPalette lerp(DSPalette? other, double t) {
    if (other == null) return this;
    return DSPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceHigh: Color.lerp(surfaceHigh, other.surfaceHigh, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}

extension DSPaletteContext on BuildContext {
  DSPalette get palette =>
      Theme.of(this).extension<DSPalette>() ?? DSPalette.dark;
}
