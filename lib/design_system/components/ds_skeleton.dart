import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_radius.dart';
import 'ds_section.dart';

/// Placeholder pulsante de uma linha de posters.
class DSSkeletonRow extends StatefulWidget {
  const DSSkeletonRow({super.key, this.itemWidth = 130});

  final double itemWidth;

  @override
  State<DSSkeletonRow> createState() => _DSSkeletonRowState();
}

class _DSSkeletonRowState extends State<DSSkeletonRow> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.4, end: 1.0).animate(_controller),
      child: DSHorizontalList(
        itemCount: 5,
        itemBuilder: (_, _) => Container(
          width: widget.itemWidth,
          decoration: const BoxDecoration(color: DSColors.surface, borderRadius: DSRadius.md),
        ),
      ),
    );
  }
}
