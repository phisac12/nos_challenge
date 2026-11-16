/// Valores injetados em tempo de build via `--dart-define`.
/// Nenhuma credencial fica versionada no repositório.
abstract final class Env {
  static const tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');
}
