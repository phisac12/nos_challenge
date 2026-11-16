import '../../core/result.dart';
import '../entities/movie.dart';
import '../entities/movie_details.dart';

/// Contrato do domínio. A implementação vive em `data/`.
abstract interface class MovieRepository {
  Future<Result<List<Movie>>> getDiscoverMovies({required int page});

  Future<Result<MovieDetails>> getMovieDetails({required int movieId});
}
