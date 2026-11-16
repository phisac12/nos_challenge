import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_spacing.dart';
import '../tokens/ds_typography.dart';
import 'ds_button.dart';

class DSErrorView extends StatelessWidget {
  const DSErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DSSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, color: context.palette.textSecondary),
            const SizedBox(height: DSSpacing.sm),
            Text(
              message,
              style: DSTypography.caption.copyWith(
                color: context.palette.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: DSSpacing.sm),
              DSButton(
                label: 'Tentar novamente',
                icon: Icons.refresh,
                variant: DSButtonVariant.ghost,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
