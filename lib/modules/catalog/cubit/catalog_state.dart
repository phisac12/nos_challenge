part of 'catalog_cubit.dart';

/// Filme já pronto para a UI: a regra de destaque foi aplicada pelo cubit.
class MovieItem extends Equatable {
  const MovieItem({required this.movie, required this.isHighlighted});

  final Movie movie;
  final bool isHighlighted;

  @override
  List<Object?> get props => [movie, isHighlighted];
}

/// Estado individual de cada secção — é isto que permite cada uma aparecer sozinha.
sealed class SectionState extends Equatable {
  const SectionState();
  @override
  List<Object?> get props => [];
}

final class SectionLoading extends SectionState {
  const SectionLoading();
}

final class SectionLoaded extends SectionState {
  const SectionLoaded(this.items);
  final List<MovieItem> items;
  @override
  List<Object?> get props => [items];
}

final class SectionError extends SectionState {
  const SectionError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

/// Efeitos de uso único (navegação / aviso), consumidos por um BlocListener.
sealed class CatalogEffect extends Equatable {
  const CatalogEffect();
}

final class OpenMovieDetail extends CatalogEffect {
  const OpenMovieDetail(this.movie);
  final Movie movie;
  @override
  List<Object?> get props => [movie];
}

final class ShowLowRatingWarning extends CatalogEffect {
  const ShowLowRatingWarning(this.movie);
  final Movie movie;
  @override
  List<Object?> get props => [movie];
}

class CatalogState extends Equatable {
  const CatalogState({required this.sections, this.effect});

  factory CatalogState.initial(List<int> pages) =>
      CatalogState(sections: {for (final p in pages) p: const SectionLoading()});

  /// page -> estado da secção. Ordem de inserção preservada (LinkedHashMap).
  final Map<int, SectionState> sections;
  final CatalogEffect? effect;

  CatalogState copyWithSection(int page, SectionState section) =>
      CatalogState(sections: {...sections, page: section}, effect: effect);

  CatalogState withEffect(CatalogEffect? effect) =>
      CatalogState(sections: sections, effect: effect);

  @override
  List<Object?> get props => [sections, effect];
}
