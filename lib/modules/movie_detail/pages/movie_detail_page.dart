import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import '../../../domain/entities/movie.dart';

/// Ecrã puramente de apresentação: recebe o filme já validado pelo CatalogCubit,
/// por isso não precisa de cubit próprio (seria só cerimónia).
class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key, required this.movie});

  final Movie movie;

  static Object heroTag(Movie movie) => 'poster-${movie.id}';

  static Route<void> route(Movie movie) =>
      MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie));

  @override
  Widget build(BuildContext context) {
    return DSScreen(
      showBack: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DSSpacing.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              children: [
                Hero(
                  tag: heroTag(movie),
                  child: DSPoster(imageUrl: movie.posterUrl),
                ),
                const SizedBox(height: DSSpacing.lg),
                Text(
                  movie.title,
                  style: DSTypography.display,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DSSpacing.md),
                DSRatingBadge(
                  rating: movie.voteAverage,
                  highlighted: true,
                  large: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
