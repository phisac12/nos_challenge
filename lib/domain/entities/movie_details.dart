import 'cast_member.dart';

/// Informação completa de um filme, vinda de `/movie/{id}`.
class MovieDetails {
  const MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.tagline,
    required this.releaseDate,
    required this.runtimeMinutes,
    required this.genres,
    required this.voteCount,
    required this.cast,
  });

  final int id;
  final String title;
  final String overview;
  final String? tagline;
  final DateTime? releaseDate;
  final int? runtimeMinutes;
  final List<String> genres;
  final int voteCount;
  final List<CastMember> cast;
}
