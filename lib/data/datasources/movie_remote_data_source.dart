import '../../network/api_client.dart';
import '../../network/endpoints.dart';
import '../models/movie_model.dart';

abstract interface class MovieRemoteDataSource {
  Future<List<MovieModel>> discoverMovies({required int page});
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  const MovieRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<MovieModel>> discoverMovies({required int page}) async {
    final json = await _client.get(Endpoints.discoverMovies, query: {'page': page});
    final results = (json['results'] as List?) ?? const [];
    return results
        .cast<Map<String, dynamic>>()
        .map(MovieModel.fromJson)
        .toList(growable: false);
  }
}
