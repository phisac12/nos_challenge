import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_radius.dart';
import '../tokens/ds_typography.dart';

enum DSButtonVariant { primary, ghost }

class DSButton extends StatelessWidget {
  const DSButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = DSButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final DSButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == DSButtonVariant.primary;
    final style = TextButton.styleFrom(
      backgroundColor: isPrimary ? DSColors.highlight : Colors.transparent,
      foregroundColor: isPrimary ? DSColors.onHighlight : DSColors.textPrimary,
      shape: const RoundedRectangleBorder(borderRadius: DSRadius.pill),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      textStyle: DSTypography.badge.copyWith(fontSize: 14),
    );
    return icon == null
        ? TextButton(onPressed: onPressed, style: style, child: Text(label))
        : TextButton.icon(
            onPressed: onPressed,
            style: style,
            icon: Icon(icon, size: 18),
            label: Text(label),
          );
  }
}
