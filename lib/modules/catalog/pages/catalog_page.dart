import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../design_system/design_system.dart';
import '../../movie_detail/pages/movie_detail_page.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../../settings/pages/settings_drawer.dart';
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
      listenWhen: (previous, current) =>
          current.effect != null && previous.effect != current.effect,
      listener: (context, state) {
        final cubit = context.read<CatalogCubit>();
        switch (state.effect) {
          case OpenMovieDetail(:final movie):
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.of(context).push(MovieDetailPage.route(movie));
          case ShowLowRatingWarning():
            DSSnackbar.showWarning(
              context,
              'Classificação baixa — detalhe indisponível.',
            );
          case null:
            break;
        }
        cubit.effectHandled();
      },
      child: DSScreen(
        title: context.select((SettingsCubit cubit) => cubit.state.appName),
        drawer: const SettingsDrawer(),
        body: BlocBuilder<CatalogCubit, CatalogState>(
          buildWhen: (previous, current) =>
              previous.sections != current.sections,
          builder: (context, state) {
            final entries = state.sections.entries.toList();
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: DSSpacing.xl),
              itemCount: entries.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(
                      DSSpacing.md,
                      DSSpacing.lg,
                      DSSpacing.md,
                      0,
                    ),
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
    switch (section.status) {
      case SectionStatus.loading:
        return const DSSkeletonRow();
      case SectionStatus.error:
        return DSErrorView(
          message: section.errorMessage ?? '',
          onRetry: () => cubit.loadSection(page),
        );
      case SectionStatus.loaded:
        return DSHorizontalList(
          itemCount: section.items.length,
          itemBuilder: (_, index) {
            final item = section.items[index];
            return DSMovieCard(
              posterUrl: item.movie.posterUrl,
              rating: item.movie.voteAverage,
              highlighted: item.isHighlighted,
              heroTag: MovieDetailPage.heroTag(item.movie),
              onTap: () => cubit.onMovieSelected(item.movie),
            );
          },
        );
    }
  }
}
