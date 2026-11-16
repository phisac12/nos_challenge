import '../../core/result.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../network/network_exception.dart';
import '../datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  const MovieRepositoryImpl(this._remote);

  final MovieRemoteDataSource _remote;

  @override
  Future<Result<List<Movie>>> getDiscoverMovies({required int page}) => _guard(
    () async =>
        (await _remote.discoverMovies(page: page))
            .map((m) => m.toEntity())
            .toList(growable: false),
    fallback: 'Não foi possível carregar os filmes.',
  );

  @override
  Future<Result<MovieDetails>> getMovieDetails({required int movieId}) =>
      _guard(
        () async => (await _remote.movieDetails(movieId: movieId)).toEntity(),
        fallback: 'Não foi possível carregar o detalhe do filme.',
      );

  /// Converte exceções em [Failure] num só sítio.
  Future<Result<T>> _guard<T>(
    Future<T> Function() action, {
    required String fallback,
  }) async {
    try {
      return Success(await action());
    } on NetworkException catch (e) {
      return Failure(e.message);
    } catch (_) {
      return Failure(fallback);
    }
  }
}
