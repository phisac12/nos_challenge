import '../../domain/entities/movie_details.dart';
import 'cast_member_model.dart';

class MovieDetailsModel {
  const MovieDetailsModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.tagline,
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
  final String? releaseDate;
  final int? runtime;
  final List<String> genres;
  final int voteCount;
  final List<CastMemberModel> cast;

  /// Espera a resposta de `/movie/{id}?append_to_response=credits`.
  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    final genresJson = (json['genres'] as List?) ?? const [];
    final credits = json['credits'] as Map<String, dynamic>?;
    final castJson = (credits?['cast'] as List?) ?? const [];
    return MovieDetailsModel(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? '',
      overview: (json['overview'] as String?) ?? '',
      tagline: json['tagline'] as String?,
      releaseDate: json['release_date'] as String?,
      runtime: json['runtime'] as int?,
      genres: genresJson
          .map((item) => (item as Map<String, dynamic>)['name'] as String)
          .toList(),
      voteCount: (json['vote_count'] as int?) ?? 0,
      cast: castJson
          .take(maxCast)
          .map((item) => CastMemberModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  MovieDetails toEntity() => MovieDetails(
    id: id,
    title: title,
    overview: overview,
    tagline: (tagline?.isEmpty ?? true) ? null : tagline,
    releaseDate: DateTime.tryParse(releaseDate ?? ''),
    runtimeMinutes: (runtime == null || runtime == 0) ? null : runtime,
    genres: genres,
    voteCount: voteCount,
    cast: cast.map((actor) => actor.toEntity()).toList(),
  );
}
