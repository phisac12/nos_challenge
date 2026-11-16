import '../../core/result.dart';
import '../entities/movie.dart';

/// Contrato do domínio. A implementação vive em `data/`.
abstract interface class MovieRepository {
  Future<Result<List<Movie>>> getDiscoverMovies({required int page});
}
