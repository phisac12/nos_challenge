import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_spacing.dart';
import '../tokens/ds_typography.dart';

/// Menu lateral com cabeçalho (ícone + título) e lista de [children].
class DSDrawer extends StatelessWidget {
  const DSDrawer({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.all(DSSpacing.lg),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(DSSpacing.sm),
                    decoration: const BoxDecoration(
                      color: DSColors.highlight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.movie_filter_rounded,
                      color: DSColors.onHighlight,
                    ),
                  ),
                  const SizedBox(width: DSSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: DSTypography.title),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: DSTypography.caption.copyWith(
                              color: context.palette.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: context.palette.surfaceHigh, height: 1),
            ...children,
          ],
        ),
      ),
    );
  }
}
