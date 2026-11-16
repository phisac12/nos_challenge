import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../design_system/design_system.dart';
import '../../movie_detail/pages/movie_detail_page.dart';
import '../cubit/catalog_cubit.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CatalogCubit>()..loadSections(),
      child: const _CatalogView(),
    );
  }
}

class _CatalogView extends StatelessWidget {
  const _CatalogView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CatalogCubit, CatalogState>(
      listenWhen: (prev, curr) => curr.effect != null && prev.effect != curr.effect,
      listener: (context, state) {
        final cubit = context.read<CatalogCubit>();
        switch (state.effect) {
          case OpenMovieDetail(:final movie):
            Navigator.of(context).push(MovieDetailPage.route(movie));
          case ShowLowRatingWarning():
            DSSnackbar.showWarning(context, 'Classificação baixa — detalhe indisponível.');
          case null:
            break;
        }
        cubit.effectHandled();
      },
      child: DSScreen(
        body: BlocBuilder<CatalogCubit, CatalogState>(
          buildWhen: (prev, curr) => prev.sections != curr.sections,
          builder: (context, state) {
            final entries = state.sections.entries.toList();
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: DSSpacing.xl),
              itemCount: entries.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(DSSpacing.md, DSSpacing.lg, DSSpacing.md, 0),
                    child: Text('Descobrir', style: DSTypography.display),
                  );
                }
                final MapEntry(key: page, value: section) = entries[index - 1];
                return DSSection(
                  title: 'Página $page',
                  child: _SectionContent(page: page, section: section),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  const _SectionContent({required this.page, required this.section});

  final int page;
  final SectionState section;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CatalogCubit>();
    return switch (section) {
      SectionLoading() => const DSSkeletonRow(),
      SectionError(:final message) => DSErrorView(message: message, onRetry: () => cubit.loadSection(page)),
      SectionLoaded(:final items) => DSHorizontalList(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final item = items[i];
            return DSMovieCard(
              posterUrl: item.movie.posterUrl,
              rating: item.movie.voteAverage,
              highlighted: item.isHighlighted,
              heroTag: MovieDetailPage.heroTag(item.movie),
              onTap: () => cubit.onMovieSelected(item.movie),
            );
          },
        ),
    };
  }
}
