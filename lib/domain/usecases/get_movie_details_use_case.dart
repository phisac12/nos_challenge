import '../../core/result.dart';
import '../entities/movie_details.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetailsUseCase {
  const GetMovieDetailsUseCase(this._repository);

  final MovieRepository _repository;

  Future<Result<MovieDetails>> call({required int movieId}) =>
      _repository.getMovieDetails(movieId: movieId);
}
