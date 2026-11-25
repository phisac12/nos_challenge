import '../../core/result.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../network/network_exception.dart';
import '../datasources/movie_remote_data_source.dart';

/// Busca os dados, converte models em entidades e erros em [Failure].
class MovieRepositoryImpl implements MovieRepository {
  const MovieRepositoryImpl(this._remote);

  final MovieRemoteDataSource _remote;

  @override
  Future<Result<List<Movie>>> getDiscoverMovies({required int page}) async {
    try {
      final models = await _remote.discoverMovies(page: page);
      final movies = models.map((model) => model.toEntity()).toList();
      return Success(movies);
    } on NetworkException catch (e) {
      return Failure(e.message);
    } catch (_) {
      return const Failure('Não foi possível carregar os filmes.');
    }
  }

  @override
  Future<Result<MovieDetails>> getMovieDetails({required int movieId}) async {
    try {
      final model = await _remote.movieDetails(movieId: movieId);
      return Success(model.toEntity());
    } on NetworkException catch (e) {
      return Failure(e.message);
    } catch (_) {
      return const Failure('Não foi possível carregar o detalhe do filme.');
    }
  }
}
