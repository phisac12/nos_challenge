part of 'catalog_cubit.dart';

/// Filme já pronto para a UI: a regra de destaque foi aplicada pelo cubit.
class MovieItem extends Equatable {
  const MovieItem({required this.movie, required this.isHighlighted});

  final Movie movie;
  final bool isHighlighted;

  @override
  List<Object?> get props => [movie, isHighlighted];
}

/// Estado de uma secção: cada uma tem o seu, por isso aparecem independentes.
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

  /// Todas as secções começam em loading.
  factory CatalogState.initial(List<int> pages) => CatalogState(
    sections: {for (final page in pages) page: const SectionLoading()},
  );

  /// Número da página → estado dessa secção.
  final Map<int, SectionState> sections;

  /// Ação de uso único pendente (navegar ou avisar). Nulo quando não há.
  final CatalogEffect? effect;

  CatalogState copyWith({
    Map<int, SectionState>? sections,
    CatalogEffect? effect,
  }) => CatalogState(
    sections: sections ?? this.sections,
    effect: effect ?? this.effect,
  );

  CatalogState clearEffect() => CatalogState(sections: sections);

  @override
  List<Object?> get props => [sections, effect];
}
