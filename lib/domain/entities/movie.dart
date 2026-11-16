class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.voteAverage,
  });

  final int id;
  final String title;
  final String? posterUrl;
  final double voteAverage;
}
