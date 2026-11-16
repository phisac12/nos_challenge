import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_spacing.dart';
import '../tokens/ds_typography.dart';

/// Linha do [DSDrawer]: ícone, título, subtítulo opcional e conteúdo extra por baixo.
class DSDrawerTile extends StatelessWidget {
  const DSDrawerTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.bottom,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DSSpacing.lg,
        vertical: DSSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: context.palette.textSecondary),
              const SizedBox(width: DSSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: DSTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: DSTypography.caption.copyWith(
                    color: context.palette.textSecondary,
                  ),
                ),
            ],
          ),
          if (bottom != null) ...[
            const SizedBox(height: DSSpacing.md),
            bottom!,
          ],
        ],
      ),
    );
  }
}
