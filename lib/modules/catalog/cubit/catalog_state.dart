part of 'catalog_cubit.dart';

/// Filme já pronto para a UI: a regra de destaque foi aplicada pelo cubit.
class MovieItem extends Equatable {
  const MovieItem({required this.movie, required this.isHighlighted});

  final Movie movie;
  final bool isHighlighted;

  @override
  List<Object?> get props => [movie, isHighlighted];
}

enum SectionStatus { loading, loaded, error }

/// Estado de uma secção: cada uma tem o seu, por isso aparecem independentes.
class SectionState extends Equatable {
  const SectionState({
    this.status = SectionStatus.loading,
    this.items = const [],
    this.errorMessage,
  });

  final SectionStatus status;

  /// Filmes da secção. Só tem conteúdo quando o status é loaded.
  final List<MovieItem> items;

  /// Mensagem de erro. Só tem valor quando o status é error.
  final String? errorMessage;

  @override
  List<Object?> get props => [status, items, errorMessage];
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
    sections: {for (final page in pages) page: const SectionState()},
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
