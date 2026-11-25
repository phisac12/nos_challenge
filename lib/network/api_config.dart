abstract final class ApiConfig {
  static const baseUrl = 'https://api.themoviedb.org/3';
  static const _imageBaseUrl = 'https://image.tmdb.org/t/p';
  static const timeout = Duration(seconds: 15);

  static String? posterUrl(String? path) => _image('w500', path);
  static String? profileUrl(String? path) => _image('w185', path);

  static String? _image(String size, String? path) =>
      (path == null || path.isEmpty) ? null : '$_imageBaseUrl/$size$path';
}
