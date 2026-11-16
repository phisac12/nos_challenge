import 'package:flutter/material.dart';

import '../tokens/ds_spacing.dart';

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
