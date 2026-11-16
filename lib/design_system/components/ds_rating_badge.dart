import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_radius.dart';
import '../tokens/ds_typography.dart';

class DSRatingBadge extends StatelessWidget {
  const DSRatingBadge({
    super.key,
    required this.rating,
    required this.highlighted,
    this.large = false,
  });

  final double rating;
  final bool highlighted;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final bg = highlighted ? DSColors.highlight : context.palette.surfaceHigh;
    final fg = highlighted
        ? DSColors.onHighlight
        : context.palette.textSecondary;
    final scale = large ? 1.6 : 1.0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 4 * scale),
      decoration: BoxDecoration(color: bg, borderRadius: DSRadius.pill),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 14 * scale, color: fg),
          SizedBox(width: 2 * scale),
          Text(
            rating.toStringAsFixed(1),
            style: DSTypography.badge.copyWith(color: fg, fontSize: 12 * scale),
          ),
        ],
      ),
    );
  }
}
