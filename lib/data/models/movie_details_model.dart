import '../../domain/entities/movie_details.dart';
import '../../network/api_config.dart';
import 'cast_member_model.dart';

class MovieDetailsModel {
  const MovieDetailsModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.tagline,
    required this.backdropPath,
    required this.releaseDate,
    required this.runtime,
    required this.genres,
    required this.voteCount,
    required this.cast,
  });

  /// Quantos atores mostrar no detalhe.
  static const maxCast = 10;

  final int id;
  final String title;
  final String overview;
  final String? tagline;
  final String? backdropPath;
  final String? releaseDate;
  final int? runtime;
  final List<String> genres;
  final int voteCount;
  final List<CastMemberModel> cast;

  /// Espera a resposta de `/movie/{id}?append_to_response=credits`.
  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    final genres = (json['genres'] as List?) ?? const [];
    final credits = json['credits'] as Map<String, dynamic>?;
    final cast = (credits?['cast'] as List?) ?? const [];
    return MovieDetailsModel(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      overview: (json['overview'] as String?) ?? '',
      tagline: json['tagline'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      runtime: json['runtime'] as int?,
      genres: genres
          .cast<Map<String, dynamic>>()
          .map((g) => g['name'] as String)
          .toList(growable: false),
      voteCount: (json['vote_count'] as int?) ?? 0,
      cast: cast
          .cast<Map<String, dynamic>>()
          .take(maxCast)
          .map(CastMemberModel.fromJson)
          .toList(growable: false),
    );
  }

  MovieDetails toEntity() => MovieDetails(
    id: id,
    title: title,
    overview: overview,
    tagline: (tagline?.isEmpty ?? true) ? null : tagline,
    backdropUrl: ApiConfig.backdropUrl(backdropPath),
    releaseDate: DateTime.tryParse(releaseDate ?? ''),
    runtimeMinutes: (runtime == null || runtime == 0) ? null : runtime,
    genres: genres,
    voteCount: voteCount,
    cast: cast.map((c) => c.toEntity()).toList(growable: false),
  );
}
