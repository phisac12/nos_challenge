import '../../core/result.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../network/network_exception.dart';
import '../datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  const MovieRepositoryImpl(this._remote);

  final MovieRemoteDataSource _remote;

  @override
  Future<Result<List<Movie>>> getDiscoverMovies({required int page}) async {
    try {
      final models = await _remote.discoverMovies(page: page);
      return Success(models.map((m) => m.toEntity()).toList(growable: false));
    } on NetworkException catch (e) {
      return Failure(e.message);
    } catch (_) {
      return const Failure('Não foi possível carregar os filmes.');
    }
  }
}
