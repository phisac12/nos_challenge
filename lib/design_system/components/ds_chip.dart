import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_radius.dart';
import '../tokens/ds_typography.dart';

/// Etiqueta informativa (género, duração, ano).
class DSChip extends StatelessWidget {
  const DSChip({super.key, required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.palette.surfaceHigh,
        borderRadius: DSRadius.pill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: context.palette.textSecondary),
            const SizedBox(width: 4),
          ],
          Text(label, style: DSTypography.caption),
        ],
      ),
    );
  }
}
