import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_spacing.dart';
import '../tokens/ds_typography.dart';

/// Avatar + nome + subtítulo (ex.: ator e personagem).
class DSPersonCard extends StatelessWidget {
  const DSPersonCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    this.width = 84,
  });

  final String name;
  final String subtitle;
  final String? imageUrl;
  final double width;

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(Icons.person, color: context.palette.textSecondary);
    return SizedBox(
      width: width,
      child: Column(
        children: [
          ClipOval(
            child: Container(
              width: width,
              height: width,
              color: context.palette.surfaceHigh,
              child: imageUrl == null
                  ? fallback
                  : CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => fallback,
                    ),
            ),
          ),
          const SizedBox(height: DSSpacing.sm),
          Text(
            name,
            style: DSTypography.caption,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: DSTypography.caption.copyWith(
              fontSize: 11,
              color: context.palette.textSecondary,
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
