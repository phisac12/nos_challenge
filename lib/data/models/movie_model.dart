import '../../domain/entities/movie.dart';
import '../../network/api_config.dart';

/// DTO: conhece o formato JSON da API. O domínio nunca o vê.
class MovieModel {
  const MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
  });

  final int id;
  final String title;
  final String? posterPath;
  final double voteAverage;

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
    id: json['id'] as int,
    title: (json['title'] as String?) ?? '',
    posterPath: json['poster_path'] as String?,
    voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
  );

  Movie toEntity() => Movie(
    id: id,
    title: title,
    posterUrl: ApiConfig.posterUrl(posterPath),
    voteAverage: voteAverage,
  );
}
