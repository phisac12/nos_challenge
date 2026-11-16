import 'package:flutter/material.dart';

/// Só tamanho e peso. A cor vem do tema (texto primário por omissão);
/// para texto secundário usa `.copyWith(color: context.palette.textSecondary)`.
abstract final class DSTypography {
  static const display = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );
  static const title = TextStyle(fontSize: 20, fontWeight: FontWeight.w700);
  static const body = TextStyle(fontSize: 14);
  static const caption = TextStyle(fontSize: 12);
  static const badge = TextStyle(fontSize: 12, fontWeight: FontWeight.w700);
}
