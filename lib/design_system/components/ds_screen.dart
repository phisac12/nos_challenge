import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_typography.dart';

/// Esqueleto padrão de qualquer ecrã da app.
class DSScreen extends StatelessWidget {
  const DSScreen({super.key, required this.body, this.title, this.showBack = false});

  final String? title;
  final Widget body;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DSColors.background,
      appBar: title == null && !showBack
          ? null
          : AppBar(
              backgroundColor: DSColors.background,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: showBack,
              title: title == null ? null : Text(title!, style: DSTypography.title),
            ),
      body: SafeArea(child: body),
    );
  }
}
