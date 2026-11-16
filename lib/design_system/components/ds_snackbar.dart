import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_radius.dart';
import '../tokens/ds_typography.dart';

abstract final class DSSnackbar {
  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: DSColors.warning,
          shape: const RoundedRectangleBorder(borderRadius: DSRadius.md),
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: DSTypography.body.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
