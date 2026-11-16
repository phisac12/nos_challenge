import '../../core/result.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

/// Um use case por serviço: ponto único e testável para "obter filmes de uma página".
class GetDiscoverMoviesUseCase {
  const GetDiscoverMoviesUseCase(this._repository);

  final MovieRepository _repository;

  Future<Result<List<Movie>>> call({required int page}) =>
      _repository.getDiscoverMovies(page: page);
}
