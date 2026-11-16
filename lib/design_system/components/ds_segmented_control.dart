import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_radius.dart';
import '../tokens/ds_typography.dart';
import 'ds_segment.dart';

/// Escolha única entre poucas opções (ex.: Sistema / Claro / Escuro).
/// Trilho arredondado com a opção selecionada destacada por dentro.
class DSSegmentedControl<T> extends StatelessWidget {
  const DSSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  final List<DSSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  static const _duration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: DSRadius.md,
      ),
      child: Row(
        children: [
          for (final s in segments)
            Expanded(
              child: _SegmentButton(
                segment: s,
                isSelected: s.value == selected,
                onTap: () => onChanged(s.value),
              ),
            ),
        ],
      ),
    );
  }
}

class _SegmentButton<T> extends StatelessWidget {
  const _SegmentButton({
    required this.segment,
    required this.isSelected,
    required this.onTap,
  });

  final DSSegment<T> segment;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = isSelected
        ? DSColors.onHighlight
        : context.palette.textSecondary;
    return Semantics(
      button: true,
      selected: isSelected,
      label: segment.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: DSSegmentedControl._duration,
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? DSColors.highlight : Colors.transparent,
            borderRadius: DSRadius.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(segment.icon, size: 18, color: fg),
              const SizedBox(height: 2),
              Text(
                segment.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DSTypography.caption.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
