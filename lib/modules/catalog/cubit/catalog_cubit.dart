import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_discover_movies_use_case.dart';

part 'catalog_state.dart';

/// Regras de negócio do catálogo:
/// - as secções são as páginas 1, 2 e 3;
/// - cada secção carrega sozinha;
/// - nota >= 6.0 destaca o filme e abre o detalhe.
class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit(this._getDiscoverMovies) : super(CatalogState.initial(pages));

  static const pages = [1, 2, 3];
  static const minRating = 6.0;

  final GetDiscoverMoviesUseCase _getDiscoverMovies;

  static bool isWellRated(Movie movie) => movie.voteAverage >= minRating;

  /// Pede as 3 páginas ao mesmo tempo, sem esperar umas pelas outras.
  void loadSections() {
    for (final page in pages) {
      loadSection(page);
    }
  }

  Future<void> loadSection(int page) async {
    _updateSection(page, const SectionLoading());

    final result = await _getDiscoverMovies(page: page);

    result.fold(
      (error) => _updateSection(page, SectionError(error)),
      (success) => _updateSection(page, SectionLoaded(_toItems(success))),
    );
  }

  void onMovieSelected(Movie movie) {
    final effect = isWellRated(movie)
        ? OpenMovieDetail(movie)
        : ShowLowRatingWarning(movie);
    emit(state.copyWith(effect: effect));
  }

  /// Chamado pela página depois de navegar ou mostrar o aviso.
  void effectHandled() => emit(state.clearEffect());

  /// Aplica a regra de destaque a cada filme.
  List<MovieItem> _toItems(List<Movie> movies) {
    return movies
        .map(
          (movie) => MovieItem(movie: movie, isHighlighted: isWellRated(movie)),
        )
        .toList();
  }

  void _updateSection(int page, SectionState section) {
    if (isClosed) return;
    final sections = {...state.sections, page: section};
    emit(state.copyWith(sections: sections));
  }
}
