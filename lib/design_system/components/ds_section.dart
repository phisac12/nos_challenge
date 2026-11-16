import 'package:flutter/material.dart';

import '../tokens/ds_spacing.dart';
import '../tokens/ds_typography.dart';

/// Secção com título e lista horizontal. Recebe o conteúdo já pronto (lista, loading ou erro).
class DSSection extends StatelessWidget {
  const DSSection({
    super.key,
    required this.title,
    required this.child,
    this.height = 205,
  });

  final String title;
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            DSSpacing.md,
            DSSpacing.lg,
            DSSpacing.md,
            DSSpacing.sm,
          ),
          child: Text(title, style: DSTypography.title),
        ),
        SizedBox(height: height, child: child),
      ],
    );
  }
}

/// Lista horizontal padrão para usar dentro de [DSSection].
class DSHorizontalList extends StatelessWidget {
  const DSHorizontalList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(width: DSSpacing.md),
      itemBuilder: itemBuilder,
    );
  }
}
