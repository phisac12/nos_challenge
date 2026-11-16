import 'package:flutter/material.dart';

import '../tokens/ds_colors.dart';
import '../tokens/ds_radius.dart';
import '../tokens/ds_spacing.dart';
import 'ds_poster.dart';
import 'ds_rating_badge.dart';

/// Card de filme. `highlighted` é decidido fora (no cubit); o DS só desenha.
class DSMovieCard extends StatelessWidget {
  const DSMovieCard({
    super.key,
    required this.posterUrl,
    required this.rating,
    required this.highlighted,
    required this.onTap,
    this.heroTag,
    this.width = 130,
  });

  final String? posterUrl;
  final double rating;
  final bool highlighted;
  final VoidCallback onTap;
  final Object? heroTag;
  final double width;

  @override
  Widget build(BuildContext context) {
    Widget poster = DSPoster(imageUrl: posterUrl, width: width);
    if (heroTag != null) poster = Hero(tag: heroTag!, child: poster);

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: highlighted ? 1 : 0.55,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: DSRadius.md,
            border: Border.all(
              color: highlighted ? DSColors.highlight : Colors.transparent,
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              poster,
              Positioned(
                top: DSSpacing.sm,
                right: DSSpacing.sm,
                child: DSRatingBadge(rating: rating, highlighted: highlighted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
