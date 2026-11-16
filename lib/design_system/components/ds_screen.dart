import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_typography.dart';

/// Esqueleto padrão de qualquer ecrã da app.
/// Com [title] ou [drawer] mostra a barra superior; com [drawer] aparece o ícone de menu.
class DSScreen extends StatelessWidget {
  const DSScreen({
    super.key,
    required this.body,
    this.title,
    this.drawer,
    this.showBack = false,
  });

  final String? title;
  final Widget body;
  final Widget? drawer;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final hasAppBar = title != null || drawer != null || showBack;
    return Scaffold(
      backgroundColor: context.palette.background,
      drawer: drawer,
      appBar: !hasAppBar
          ? null
          : AppBar(
              automaticallyImplyLeading: showBack || drawer != null,
              title: title == null
                  ? null
                  : Text(title!, style: DSTypography.title),
            ),
      body: SafeArea(child: body),
    );
  }
}
