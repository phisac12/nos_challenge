import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_typography.dart';

/// Faixa no canto do ecrã que identifica ambientes não produtivos (DEV, QA).
class DSFlavorBanner extends StatelessWidget {
  const DSFlavorBanner({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Banner(
      message: label,
      location: BannerLocation.topEnd,
      color: DSColors.warning,
      textStyle: DSTypography.badge.copyWith(color: Colors.white, fontSize: 10),
      child: child,
    );
  }
}
