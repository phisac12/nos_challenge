import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../design_system/design_system.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_details.dart';
import '../cubit/movie_detail_cubit.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key, required this.movie});

  final Movie movie;

  static Object heroTag(Movie movie) => 'poster-${movie.id}';

  static Route<void> route(Movie movie) =>
      MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MovieDetailCubit>(param1: movie)..load(),
      child: const _MovieDetailView(),
    );
  }
}

class _MovieDetailView extends StatelessWidget {
  const _MovieDetailView();

  @override
  Widget build(BuildContext context) {
    final movie = context.select((MovieDetailCubit c) => c.state.movie);
    return DSScreen(
      showBack: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: DSSpacing.xl),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              children: [
                // Requisito: poster + classificação, visíveis de imediato.
                Hero(
                  tag: MovieDetailPage.heroTag(movie),
                  child: DSPoster(imageUrl: movie.posterUrl, width: 220),
                ),
                const SizedBox(height: DSSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg),
                  child: Text(
                    movie.title,
                    style: DSTypography.display,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: DSSpacing.md),
                DSRatingBadge(
                  rating: movie.voteAverage,
                  highlighted: true,
                  large: true,
                ),
                // Informação extra de /movie/{id}.
                BlocBuilder<MovieDetailCubit, MovieDetailState>(
                  buildWhen: (p, c) => p.status != c.status,
                  builder: (context, state) => switch (state.status) {
                    DetailsLoading() => const _DetailsSkeleton(),
                    DetailsError(:final message) => Padding(
                      padding: const EdgeInsets.only(top: DSSpacing.lg),
                      child: DSErrorView(
                        message: message,
                        onRetry: context.read<MovieDetailCubit>().load,
                      ),
                    ),
                    DetailsLoaded(:final details) => _DetailsContent(
                      details: details,
                    ),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  const _DetailsContent({required this.details});

  final MovieDetails details;

  @override
  Widget build(BuildContext context) {
    final year = MovieDetailCubit.formatYear(details.releaseDate);
    final runtime = MovieDetailCubit.formatRuntime(details.runtimeMinutes);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            DSSpacing.lg,
            DSSpacing.sm,
            DSSpacing.lg,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${details.voteCount} votos',
                style: DSTypography.caption,
                textAlign: TextAlign.center,
              ),
              if (details.tagline != null) ...[
                const SizedBox(height: DSSpacing.md),
                Text(
                  '“${details.tagline}”',
                  style: DSTypography.body.copyWith(
                    fontStyle: FontStyle.italic,
                    color: DSColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: DSSpacing.lg),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: DSSpacing.sm,
                runSpacing: DSSpacing.sm,
                children: [
                  if (year != null)
                    DSChip(label: year, icon: Icons.calendar_today_rounded),
                  if (runtime != null)
                    DSChip(label: runtime, icon: Icons.schedule_rounded),
                  for (final g in details.genres) DSChip(label: g),
                ],
              ),
              if (details.overview.isNotEmpty) ...[
                const SizedBox(height: DSSpacing.lg),
                const Text('Sinopse', style: DSTypography.title),
                const SizedBox(height: DSSpacing.sm),
                Text(
                  details.overview,
                  style: DSTypography.body.copyWith(height: 1.5),
                ),
              ],
            ],
          ),
        ),
        if (details.cast.isNotEmpty)
          DSSection(
            title: 'Elenco',
            height: 150,
            child: DSHorizontalList(
              itemCount: details.cast.length,
              itemBuilder: (_, i) {
                final c = details.cast[i];
                return DSPersonCard(
                  name: c.name,
                  subtitle: c.character,
                  imageUrl: c.profileUrl,
                );
              },
            ),
          ),
      ],
    );
  }
}

class _DetailsSkeleton extends StatelessWidget {
  const _DetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(DSSpacing.lg),
      child: Column(
        children: [
          DSSkeletonBlock(width: 180, height: 28),
          SizedBox(height: DSSpacing.lg),
          DSSkeletonBlock(),
          SizedBox(height: DSSpacing.sm),
          DSSkeletonBlock(),
          SizedBox(height: DSSpacing.sm),
          DSSkeletonBlock(width: 200),
        ],
      ),
    );
  }
}
