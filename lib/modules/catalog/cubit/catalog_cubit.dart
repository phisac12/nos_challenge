import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/result.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_discover_movies_use_case.dart';

part 'catalog_state.dart';

/// Concentra as regras de negócio do catálogo:
/// - quais páginas formam as secções;
/// - carregamento independente de cada secção;
/// - limiar de classificação (destaque e acesso ao detalhe).
class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit(this._getDiscoverMovies, {this.pages = defaultPages})
    : super(CatalogState.initial(pages));

  static const defaultPages = [1, 2, 3];
  static const minRating = 6.0;

  /// Injetado pelo construtor e privado: só o cubit o usa.
  final GetDiscoverMoviesUseCase _getDiscoverMovies;
  final List<int> pages;

  static bool isWellRated(Movie movie) => movie.voteAverage >= minRating;

  /// Dispara as secções em paralelo, sem `await` conjunto:
  /// cada uma emite assim que a sua resposta chega.
  void loadSections() {
    for (final page in pages) {
      loadSection(page);
    }
  }

  Future<void> loadSection(int page) async {
    _emitSection(page, const SectionLoading());
    final result = await _getDiscoverMovies(page: page);
    _emitSection(page, switch (result) {
      Success(:final data) => SectionLoaded(
        data
            .map((m) => MovieItem(movie: m, isHighlighted: isWellRated(m)))
            .toList(growable: false),
      ),
      Failure(:final message) => SectionError(message),
    });
  }

  void onMovieSelected(Movie movie) {
    emit(
      state.withEffect(
        isWellRated(movie)
            ? OpenMovieDetail(movie)
            : ShowLowRatingWarning(movie),
      ),
    );
  }

  void effectHandled() => emit(state.withEffect(null));

  void _emitSection(int page, SectionState section) {
    if (isClosed) return;
    emit(state.copyWithSection(page, section));
  }
}
