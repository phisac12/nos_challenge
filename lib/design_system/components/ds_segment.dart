import 'package:flutter/widgets.dart';

/// Opção de um [DSSegmentedControl].
class DSSegment<T> {
  const DSSegment({
    required this.value,
    required this.label,
    required this.icon,
  });

  final T value;
  final String label;
  final IconData icon;
}
