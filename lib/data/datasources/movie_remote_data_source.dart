import '../../network/api_client.dart';
import '../../network/endpoints.dart';
import '../models/movie_details_model.dart';
import '../models/movie_model.dart';

abstract interface class MovieRemoteDataSource {
  Future<List<MovieModel>> discoverMovies({required int page});

  Future<MovieDetailsModel> movieDetails({required int movieId});
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  const MovieRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<MovieModel>> discoverMovies({required int page}) async {
    final json = await _client.get(
      Endpoints.discoverMovies,
      query: {'page': page},
    );
    final results = (json['results'] as List?) ?? const [];
    return results
        .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Um só pedido traz detalhe + elenco (`append_to_response=credits`).
  @override
  Future<MovieDetailsModel> movieDetails({required int movieId}) async {
    final json = await _client.get(
      Endpoints.movieDetails(movieId),
      query: {'append_to_response': 'credits'},
    );
    return MovieDetailsModel.fromJson(json);
  }
}
