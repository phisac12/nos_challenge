import 'package:flutter/material.dart';

import 'ds_colors.dart';

abstract final class DSTypography {
  static const display = TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: DSColors.textPrimary, letterSpacing: -0.5);
  static const title = TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: DSColors.textPrimary);
  static const body = TextStyle(fontSize: 14, color: DSColors.textPrimary);
  static const caption = TextStyle(fontSize: 12, color: DSColors.textSecondary);
  static const badge = TextStyle(fontSize: 12, fontWeight: FontWeight.w700);
}
