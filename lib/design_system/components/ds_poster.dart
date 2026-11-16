import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_radius.dart';

/// Poster com cache, placeholder e fallback. Não conhece a API: recebe só a URL.
class DSPoster extends StatelessWidget {
  const DSPoster({
    super.key,
    required this.imageUrl,
    this.width,
    this.borderRadius = DSRadius.md,
  });

  final String? imageUrl;
  final double? width;
  final BorderRadius borderRadius;

  static const aspectRatio = 2 / 3;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: DSColors.surfaceHigh,
      alignment: Alignment.center,
      child: const Icon(Icons.movie_outlined, color: DSColors.textSecondary),
    );
    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: imageUrl == null
              ? fallback
              : CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(color: DSColors.surface),
                  errorWidget: (_, _, _) => fallback,
                ),
        ),
      ),
    );
  }
}
