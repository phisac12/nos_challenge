import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_radius.dart';

/// Bloco de placeholder para texto ou imagem enquanto carrega.
class DSSkeletonBlock extends StatelessWidget {
  const DSSkeletonBlock({
    super.key,
    this.width = double.infinity,
    this.height = 14,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: DSRadius.sm,
      ),
    );
  }
}
