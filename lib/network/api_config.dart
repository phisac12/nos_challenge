abstract final class ApiConfig {
  static const baseUrl = 'https://api.themoviedb.org/3';
  static const imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const timeout = Duration(seconds: 15);

  static String? posterUrl(String? posterPath) =>
      (posterPath == null || posterPath.isEmpty) ? null : '$imageBaseUrl$posterPath';
}
